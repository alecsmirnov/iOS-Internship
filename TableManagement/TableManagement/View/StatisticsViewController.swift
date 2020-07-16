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
    
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var maxValueLabel: UILabel!
    @IBOutlet private var minValueLabel: UILabel!
    @IBOutlet private var averageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let statisticsViewModel = statisticsViewModel {
            countLabel.text = String("Items count: \(statisticsViewModel.count())")
            maxValueLabel.text = String("Max value: \(statisticsViewModel.max())")
            minValueLabel.text = String("Min value: \(statisticsViewModel.min())")
            averageLabel.text = String("Average: \(statisticsViewModel.average())")
        }
    }
}
