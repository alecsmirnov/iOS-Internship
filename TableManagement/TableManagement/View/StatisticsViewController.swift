//
//  StatisticsViewController.swift
//  TableManagement
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    var statisticsViewModel: StatisticsViewModel!
    var graphView: GraphView!
    
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var maxValueLabel: UILabel!
    @IBOutlet private var minValueLabel: UILabel!
    @IBOutlet private var averageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let graphView = graphView {
            
            graphView.frame = CGRect(x: 10, y: 10, width: view.frame.width - 10 * 2, height: view.frame.height / 2 - 10 * 2)
            
            view.addSubview(graphView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let statisticsViewModel = statisticsViewModel {
            countLabel.text = String("Items count: \(statisticsViewModel.count)")
            maxValueLabel.text = String("Max value: \(statisticsViewModel.max())")
            minValueLabel.text = String("Min value: \(statisticsViewModel.min())")
            averageLabel.text = String("Average: \(statisticsViewModel.average())")
        }
    }
}
