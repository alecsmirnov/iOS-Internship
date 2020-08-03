//
//  StatisticsViewController.swift
//  TableManagement
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum GraphSettings {
    static let xStep = 10
    static let yStep = 10
    
    static let xBorder = 100
    static let yBorder = 100
}

class StatisticsViewController: UIViewController {
    var statisticsViewModel: StatisticsViewModel!
    
    @IBOutlet private var graphView: GraphView!
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var maxValueLabel: UILabel!
    @IBOutlet private var minValueLabel: UILabel!
    @IBOutlet private var averageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let graphView = graphView {
            graphView.xStep = GraphSettings.xStep
            graphView.yStep = GraphSettings.yStep
            
            graphView.xBorder = GraphSettings.xBorder
            graphView.yBorder = GraphSettings.yBorder
            
            graphView.xPercentageStep = true
            graphView.yPercentageStep = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let statisticsViewModel = statisticsViewModel {
            countLabel.text = String("Items count: \(statisticsViewModel.count)")
            maxValueLabel.text = String("Max value: \(statisticsViewModel.max())")
            minValueLabel.text = String("Min value: \(statisticsViewModel.min())")
            averageLabel.text = String("Average: \(statisticsViewModel.average())")
            
            if let graphView = graphView {
                graphView.numbers = statisticsViewModel.numbers()
                graphView.setNeedsDisplay()
            }
        }
    }
}
