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
    
    override func viewDidAppear(_ animated: Bool) {
        showStatistics()
    }
    
    private func showStatistics() {
        if let unwrappedDataSource = dataSource {
            countLabel.text = String("Items count: \(unwrappedDataSource.data.count)")
            maxValueLabel.text = String("Max value: \(unwrappedDataSource.data.max()!)")
            minValueLabel.text = String("Min value: \(unwrappedDataSource.data.min()!)")
            averageLabel.text = String(format: "Average: %.3f ", Double(unwrappedDataSource.data.reduce(0, +)) / Double(unwrappedDataSource.data.count))
        }
    }
}
