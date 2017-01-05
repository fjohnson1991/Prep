//
//  ChartViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/4/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import Charts
import Foundation

protocol GetChartData {
    func getChartData(with dataPoints: [String], values: [String])
    var workoutDuration: [String] {get set}
    var beatsPerMinute: [String] {get set}
}

class ChartViewController: UIViewController, GetChartData {

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
        
        self.getChartData(with: workoutDuration, values: beatsPerMinute)
        
        let barChart = BarChart(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height))
        barChart.delegate = self
        self.view.addSubview(barChart)
        
        //barChartSetup()
        //lineChartSetup()
        //cublicLineChartSetup()
    }
    
    func getChartData(with dataPoints: [String], values: [String]) {
        self.workoutDuration = dataPoints
        self.beatsPerMinute = values
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
    
    func cublicLineChartSetup() {
        
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
        setCublicLineChart(dataPoints: workoutDuration, values: beatsPerMinute)
    }
    
    func setCublicLineChart(dataPoints: [String], values: [String]) {
        
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
        chartDataSet.mode = .cubicBezier
        chartDataSet.cubicIntensity = 0.2
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.valueFont = UIFont(name: "Helvetica", size: 12.0)!
        
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
