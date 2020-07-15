//
//  StatisticsViewController.swift
//  TableManagement
//
//  Created by Admin on 02.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    //weak var numbersDataViewModel: NumbersDataViewModel! {
    //  didSet {
    //
    //
    //  }
    //}
    var numbersData: NumbersData?
    
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
        if let numbersData = numbersData {
            var countString: String = "0"
            var maxString: String = "-"
            var minString: String = "-"
            var averageString: String = "-"
            
            if !numbersData.isEmpty() {
                let data = numbersData.arrayData()
                
                countString = String(data.count)
                maxString = String(data.max()!)
                minString = String(data.min()!)
                
                let average: Double = Double(data.reduce(0, +)) / Double(data.count)
                averageString = String(format: "%.3f", average)
            }
            
            countLabel.text = String("Items count: \(countString)")
            maxValueLabel.text = String("Max value: \(maxString)")
            minValueLabel.text = String("Min value: \(minString)")
            averageLabel.text = String("Average: \(averageString)")
        }
    }
}
