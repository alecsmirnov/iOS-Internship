//
//  StatisticsViewController.swift
//  TableManagement
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    var dataSource: DataSource?
    
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var maxValueLabel: UILabel!
    @IBOutlet private var minValueLabel: UILabel!
    @IBOutlet private var averageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showStatistics()
    }
    
    private func showStatistics() {
        if let unwrappedDataSource = dataSource {
            var maxString: String = "-"
            var minString: String = "-"
            var averageString: String = "-"
            
            if !unwrappedDataSource.data.isEmpty {
                maxString = String(unwrappedDataSource.data.max()!)
                minString = String(unwrappedDataSource.data.min()!)
                
                let average: Double = Double(unwrappedDataSource.data.reduce(0, +)) / Double(unwrappedDataSource.data.count)
                averageString = String(format: "%.3f", average)
            }
            
            countLabel.text = String("Items count: \(unwrappedDataSource.data.count)")
            maxValueLabel.text = String("Max value: \(maxString)")
            minValueLabel.text = String("Min value: \(minString)")
            averageLabel.text = String("Average: \(averageString)")
        }
    }
}
