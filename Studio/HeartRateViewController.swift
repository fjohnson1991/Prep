//
//  HeartRateViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/6/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import CoreBluetooth
import Foundation
import AVFoundation
import AVKit

class HeartRateViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    var centralManager: CBCentralManager!
    var connectingPeripheral: CBPeripheral!
    var classParticipant: User!
    var totalParticipants: [User]!
    var sectionInsets: UIEdgeInsets!
    var itemSize: CGSize!
    var referenceSize: CGSize!
    var numberOfRows: CGFloat!
    var numberOfColumns: CGFloat!
    var convertedImage: UIImage!
    var insetSpacing: CGFloat!
    var minimumInterItemSpacing: CGFloat!
    var minimumLineSpacing: CGFloat!
    var movieView = UIView()
    var player: AVPlayer!
    var controller = AVPlayerViewController()
    var currentBPMLabel = UILabel()
    var invisibleButton = UIButton()
    var isPlaying = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        configViews()
        FirebaseMethods.removePreviousCurrentClassData()
        
        //Timers
        _ = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(HeartRateViewController.updateBPM), userInfo: nil, repeats: true)
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HeartRateViewController.liveBPMUpdateLabel), userInfo: nil, repeats: true)
        
    }
    
    //MARK: Config view
    func configViews() {
        FirebaseMethods.retrieveAllUsersInClass(with: "exerciseClassID1234") { (users) in
            self.totalParticipants = users
            self.bannerCollectionView.reloadData()
            self.cellConfig()
            self.configVideo()
            self.bannerCollectionView.delegate = self
            self.bannerCollectionView.dataSource = self
            self.bannerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            self.bannerCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.bannerCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
            self.bannerCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            self.bannerCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.bannerCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            self.view.addSubview(self.bannerCollectionView)
            self.bannerCollectionView.isUserInteractionEnabled = false
            self.bannerCollectionView.showsHorizontalScrollIndicator = true
            self.liveBPMUpdateLabel()
            _ = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HeartRateViewController.autoScroll), userInfo: nil, repeats: true)
        }
    }
    
    //MARK: Movie Config
    func configVideo() {
        self.movieView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.movieView)
        self.movieView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.movieView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.movieView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.movieView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        guard let url: URL = URL(string: "http://devstreaming.apple.com/videos/wwdc/2016/102w0bsn0ge83qfv7za/102/hls_vod_mvp.m3u8") else { print("video URL error"); return }
        player = AVPlayer(url: url)
        controller.player = player
        controller.view.frame = self.movieView.bounds
        movieView.addSubview(controller.view)
        
        invisibleButton.translatesAutoresizingMaskIntoConstraints = false
        movieView.addSubview(invisibleButton)
        invisibleButton.topAnchor.constraint(equalTo: self.movieView.topAnchor).isActive = true
        invisibleButton.bottomAnchor.constraint(equalTo: self.movieView.bottomAnchor, constant: 0).isActive = true
        invisibleButton.leadingAnchor.constraint(equalTo: self.movieView.leadingAnchor).isActive = true
        invisibleButton.trailingAnchor.constraint(equalTo: self.movieView.trailingAnchor).isActive = true
        invisibleButton.addTarget(self, action: #selector(handleTapGesture(_:)), for: .touchDown)
        player.play()
        isPlaying = true
    }
    
    //MARK: Pause & play tap config
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if isPlaying == true {
            print("CURRENT PAUSE TIME: \(self.player.currentTime().value)")
            print("pause")
            self.player.pause()
            self.isPlaying = false
        } else {
            print("CURRENT PLAY TIME: \(self.player.currentTime().value)")
            print("play")
            self.player.play()
            self.isPlaying = true
        }
    }
    
    //MARK: BPM live update
    func liveBPMUpdateLabel() {
        self.currentBPMLabel.translatesAutoresizingMaskIntoConstraints = false
        self.movieView.addSubview(self.currentBPMLabel)
        self.currentBPMLabel.topAnchor.constraint(equalTo: self.movieView.topAnchor, constant: 20).isActive = true
        self.currentBPMLabel.leadingAnchor.constraint(equalTo: self.movieView.leadingAnchor, constant: 20).isActive = true
        self.currentBPMLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        self.currentBPMLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.currentBPMLabel.layer.cornerRadius = 3.0
        self.currentBPMLabel.layer.backgroundColor = UIColor.orange.withAlphaComponent(0.3).cgColor
        self.currentBPMLabel.textColor = UIColor.white
        self.currentBPMLabel.font = UIFont(name: "Helvetica", size: 15)
        
        FirebaseMethods.getCurrentUsersLiveUpdateBPM { (bpm) in
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "HeartrateChart")
            let attachmentString = NSAttributedString(attachment: attachment)
            let bpmString = NSAttributedString(string: " \(bpm)")
            let myString = NSMutableAttributedString(string: "")
            myString.append(attachmentString)
            myString.append(bpmString)
            self.currentBPMLabel.attributedText = myString
            self.currentBPMLabel.textAlignment = .center
        }
    }
    
    //MARK: BPM timer update
    func updateBPM() {
        FirebaseMethods.retrieveAllUsersInClass(with: "exerciseClassID1234") { (users) in
            self.totalParticipants = users
            self.bannerCollectionView.reloadData()
        }
    }
    
    //MARK: Landscape mode
    private func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscapeLeft
    }
    private func shouldAutorotate() -> Bool {
        return true
    }
    
    //MARK: CollectionView Setup
    func cellConfig() {
        let screedWidth = view.frame.width
        let screenHeight = view.frame.height
        
        let numOfRows = CGFloat(1.0)
        let numOfColumns = CGFloat(3.0)
        
        insetSpacing = 0
        minimumInterItemSpacing = 0
        minimumLineSpacing = 0
        sectionInsets = UIEdgeInsetsMake(insetSpacing, insetSpacing, insetSpacing, insetSpacing)
        referenceSize = CGSize(width: screedWidth, height: 100)
        
        let totalWidthDeduction = (minimumInterItemSpacing + minimumInterItemSpacing + sectionInsets.right + sectionInsets.left)
        let totalHeightDeduction = (sectionInsets.right + sectionInsets.left + minimumLineSpacing + minimumLineSpacing)
        
        itemSize = CGSize(width: (screedWidth - totalWidthDeduction)/numOfColumns, height: (screenHeight - totalHeightDeduction)/numOfRows)
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCellIdentifier", for: indexPath) as! BannerCollectionViewCell
        let currentPost = totalParticipants[indexPath.row]
        cell.user = currentPost
        return cell
    }
    
    //MARK: UICollectionView continuous scrolling
    func autoScroll() {
        self.bannerCollectionView.performBatchUpdates({
            let firstItem = self.totalParticipants.remove(at: 0)
            self.totalParticipants.append(firstItem)
        }) { (finished) in
            self.bannerCollectionView.reloadData()
        }
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    //MARK: Bluetooth funcs
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
            print("BPM: \(bpm)")
            FirebaseMethods.sendBPMToFirebase(with: "exerciseClassID1234", bpm: "\(bpm)")
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
