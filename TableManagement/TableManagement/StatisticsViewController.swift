//
//  StatisticsViewController.swift
//  TableManagement
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    private weak var delegate: TableViewControllerDelegate?
    
    @IBOutlet private var countLabel: UILabel!
    @IBOutlet private var maxValueLabel: UILabel!
    @IBOutlet private var minValueLabel: UILabel!
    @IBOutlet private var averageLabel: UILabel!
    
    func setDelegate(delegate: TableViewControllerDelegate) {
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Error
        //showStatistics()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showStatistics()
    }
    
    private func showStatistics() {
        let tableData = delegate!.numbers()
        
        countLabel.text = String("Items count: \(tableData.count)")
        maxValueLabel.text = String("Max value: \(tableData.max()!)")
        minValueLabel.text = String("Min value: \(tableData.min()!)")
        averageLabel.text = String(format: "Average: %.3f ", Double(tableData.reduce(0, +)) / Double(tableData.count))
    }
}
