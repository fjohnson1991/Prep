//
//  HeartRateViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/4/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import Charts
import Foundation

class ChartViewController: UIViewController {

    // Bar chart properties
    let barChartView = BarChartView()
    var dataEntry: [BarChartDataEntry] = []
    
    // Bar chart data
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barChartSetup()
    }
    
    func barChartSetup() {
        
        // Bar chart config
        self.view.backgroundColor = UIColor.white
        view.addSubview(barChartView)
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        barChartView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        barChartView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        barChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        barChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // Bar chart data
        workoutDuration = ["1","2","3","4","5","6","7","8","9","10"]
        beatsPerMinute = ["76","150", "160", "180", "195", "195", "180", "164", "136", "112"]
        
        // Bar chart population
        setChart(dataPoints: workoutDuration, values: beatsPerMinute)
    }
    
    func setChart(dataPoints: [String], values: [String]) {
    
        // No data setup
        barChartView.noDataTextColor = UIColor.white
        barChartView.noDataText = "No data for the chart."
        barChartView.backgroundColor = UIColor.white
        
        // Data point setup
        for i in 0..<dataPoints.count {
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntry.append(dataPoint)
        }

        let chartDataSet = BarChartDataSet(values: dataEntry, label: "BPM")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false) // true if want values above bar
        
        // Axes setup
        let formatter:BarChartFormatter = BarChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()
        xaxis.valueFormatter = formatter
        barChartView.xAxis.labelPosition = .bottom
        barChartView.xAxis.drawGridLinesEnabled = false // true if want X-Axis grid lines
        barChartView.xAxis.valueFormatter = xaxis.valueFormatter
        barChartView.chartDescription?.enabled = false
        barChartView.legend.enabled = true
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.drawGridLinesEnabled = false // true if want Y-Axis grid lines
        barChartView.leftAxis.drawLabelsEnabled = true
        barChartView.data = chartData
    }
}

// MARK: - BarChartFormatter required to config xaxis

public class BarChartFormatter: NSObject, IAxisValueFormatter {
    
    var workoutDuration = [String]()

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return workoutDuration[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.workoutDuration = values
    }
}
