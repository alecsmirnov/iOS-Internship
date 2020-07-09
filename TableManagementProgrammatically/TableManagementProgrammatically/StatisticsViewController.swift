//
//  StatisticsViewController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    var dataSource: DataSource?
    
    private enum LabelsId {
        static let count: Int = 0
        static let maxValue: Int = 1
        static let minValue: Int = 2
        static let average: Int = 3
    }
    
    private var countLabel: UILabel!
    private var maxValueLabel: UILabel!
    private var minValueLabel: UILabel!
    private var averageLabel: UILabel!
    
    override func loadView() {
        setupView()
        setupLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showStatistics()
    }
    
    private func setupView() {
        view = UIView()
        
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .white
    }
    
    private func setupLabels() {
        let center = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        let width: CGFloat = 200
        let height: CGFloat = 30
        
        let labelsCount: Int = 4
        let labelsDistance: CGFloat = 30
        var labels: [UILabel] = []
        
        for i in 0..<labelsCount {
            let newLabel = UILabel(frame: CGRect(x: center.x - width / 2, y: center.y - 100 + labelsDistance * CGFloat(i), width: width, height: height))
            
            labels.append(newLabel)
            labels[i].textAlignment = .center
             
            view.addSubview(labels[i])
         }
        
        countLabel = labels[LabelsId.count]
        maxValueLabel = labels[LabelsId.maxValue]
        minValueLabel = labels[LabelsId.minValue]
        averageLabel = labels[LabelsId.average]
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
