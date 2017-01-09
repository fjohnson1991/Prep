//
//  HeartRateViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/6/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import CoreBluetooth

class HeartRateViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    var centralManager: CBCentralManager!
    var connectingPeripheral: CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
        FirebaseMethods.getCurrentUsersLiveUpdateBPM(with: "exerciseClassID1234") { (bpm) in
            print("LIVE UPDATE BPM: \(bpm)")
        }
        
        FirebaseMethods.retrieveAllUsersInClass(with: "exerciseClassID1234") { (users) in
            for user in users {
                print("USER: \(user.name): \(user.bpm)")
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("powered on")
            
            let serviceUUIDs = [CBUUID(string: "180D")]
            let lastPeripherals = centralManager.retrieveConnectedPeripherals(withServices: serviceUUIDs)
            
            if lastPeripherals.count > 0 {
                print("iperipherals")
                let device = lastPeripherals.last! as CBPeripheral;
                connectingPeripheral = device;
                centralManager.connect(connectingPeripheral, options: nil)
            } else {
                print("serviceUUIDs: \(serviceUUIDs); started scanning")
                centralManager.scanForPeripherals(withServices: serviceUUIDs, options: nil)
            }
            
        case .poweredOff:
            print("powered off")
            
        case .unsupported:
            print("unsupported")
            
        case .unauthorized:
            print("unauthorized")
            
        default:
            print("State: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        connectingPeripheral = peripheral
        connectingPeripheral.delegate = self
        centralManager.connect(connectingPeripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        print("did connect")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("Error: \(error)")
        } else {
            for service in peripheral.services as [CBService]!{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("Error: \(error)")
        } else {
            if service.uuid == CBUUID(string: "180D") {
                for characteristic in service.characteristics! as [CBCharacteristic] {
                    switch characteristic.uuid.uuidString {
                    case "2A37":
                        print("heart rate characteristic found")
                        peripheral.setNotifyValue(true, for: characteristic)
                        
                    case "2A38":
                        print("Body Sensor Location Characteristic found")
                        peripheral.readValue(for: characteristic)
                        
                    case "2A39":
                        print("Heart Rate Control Point Characteristic found")
                        var rawArray: [UInt8] = [0x01]
                        let data = NSData(bytes: &rawArray, length: rawArray.count)
                        peripheral.writeValue(data as Data, for: characteristic, type: .withResponse)
                        
                    default:
                        print("default")
                    }
                }
            }
        }
    }
    
    func update(heartRateData: NSData) {
        var buffer = [UInt8](repeating:0, count:heartRateData.length)
        heartRateData.getBytes(&buffer, length: heartRateData.length)
        
        var bpm: UInt16?
        if buffer.count >= 2 {
            if buffer[0] & 0x01 == 0 {
                bpm = UInt16(buffer[1])
            } else {
                bpm = UInt16(buffer[1]) << 8
                bpm =  bpm! | UInt16(buffer[2])
            }
        }
        
        if let actualBPM = bpm {
            print("Actual BPM: \(actualBPM)")
            FirebaseMethods.sendBPMToFirebase(with: "exerciseClassID1234", bpm: "\(actualBPM)")
        } else {
            FirebaseMethods.sendBPMToFirebase(with: "exerciseClassID1234", bpm: "\(bpm)")
            print("BPM: \(bpm)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("Error: \(error)")
        } else {
            switch characteristic.uuid.uuidString {
                case "2A37":
                    let data = NSData(data: characteristic.value!)
                    update(heartRateData: data)
                    print("did update value for data \(data)")
                
            default:
                print("default")
            }
        }
    }
}
