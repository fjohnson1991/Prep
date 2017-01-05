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
    
    // Line graph properties
    let lineChartView = LineChartView()
    var lineDataEntry: [ChartDataEntry] = []
    
    // Chart data
    var workoutDuration = [String]()
    var beatsPerMinute = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate chart data
        workoutDuration = ["1","2","3","4","5","6","7","8","9","10"]
        beatsPerMinute = ["76","150", "160", "180", "195", "195", "180", "164", "136", "112"]
        
        //barChartSetup()
        lineChartSetup()
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

        // Bar chart animation
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
        
        // Bar chart population
        setBarChart(dataPoints: workoutDuration, values: beatsPerMinute)
    }
    
    func setBarChart(dataPoints: [String], values: [String]) {
    
        // No data setup
        barChartView.noDataTextColor = UIColor.white
        barChartView.noDataText = "No data for the chart."
        barChartView.backgroundColor = UIColor.white
        
        // Data point setup & color config
        for i in 0..<dataPoints.count {
            let dataPoint = BarChartDataEntry(x: Double(i), y: Double(values[i])!)
            dataEntry.append(dataPoint)
        }

        let chartDataSet = BarChartDataSet(values: dataEntry, label: "BPM")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(false) // true if want values above bar
        chartDataSet.colors = [UIColor.themePink]

        // Axes setup
        let formatter: ChartFormatter = ChartFormatter()
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
    
    func lineChartSetup() {
        
        // Line chart config
        self.view.backgroundColor = UIColor.white
        view.addSubview(lineChartView)
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        lineChartView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        lineChartView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        lineChartView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        // Line chart animation
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInSine)
        
        // Line chart population
        setLineChart(dataPoints: workoutDuration, values: beatsPerMinute)
    }
    
    func setLineChart(dataPoints: [String], values: [String]) {
        
        // No data setup
        lineChartView.noDataTextColor = UIColor.white
        lineChartView.noDataText = "No data for the chart."
        lineChartView.backgroundColor = UIColor.white
        
        // Data point setup & color config
        for i in 0..<dataPoints.count {
            let dataPoint = ChartDataEntry(x: Double(i), y: Double(values[i])!)
            lineDataEntry.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(values: lineDataEntry, label: "BPM")
        let chartData = LineChartData()
        chartData.addDataSet(chartDataSet)
        chartData.setDrawValues(true) // false if don't want values above bar
        chartDataSet.colors = [UIColor.themePink]
        chartDataSet.setCircleColor(UIColor.themePink)
        chartDataSet.circleHoleColor = UIColor.themePink
        chartDataSet.circleRadius = 4.0
        
        // Gradient fill
        let gradientColors = [UIColor.themePink.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations: [CGFloat] = [1.0, 0.0] // positioning of gradient
        guard let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else { print("gradient error"); return }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        // Axes setup
        let formatter: ChartFormatter = ChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()
        xaxis.valueFormatter = formatter
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false // true if want X-Axis grid lines
        lineChartView.xAxis.valueFormatter = xaxis.valueFormatter
        lineChartView.chartDescription?.enabled = false
        lineChartView.legend.enabled = true
        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false // true if want Y-Axis grid lines
        lineChartView.leftAxis.drawLabelsEnabled = true
        lineChartView.data = chartData
    }
}

// MARK: - ChartFormatter required to config xaxis

public class ChartFormatter: NSObject, IAxisValueFormatter {
    
    var workoutDuration = [String]()

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return workoutDuration[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.workoutDuration = values
    }
}
