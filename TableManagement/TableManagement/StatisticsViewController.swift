//
//  StatisticsViewController.swift
//  TableManagement
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    var tableData: [Int] = []
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var maxValueLabel: UILabel!
    @IBOutlet var minValueLabel: UILabel!
    @IBOutlet var averageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countLabel.text = String("Items count: \(tableData.count)")
        maxValueLabel.text = String("Max value: \(tableData.max()!)")
        minValueLabel.text = String("Min value: \(tableData.min()!)")
        averageLabel.text = String(format: "Average: %.3f ", Double(tableData.reduce(0, +)) / Double(tableData.count))
    }
}
