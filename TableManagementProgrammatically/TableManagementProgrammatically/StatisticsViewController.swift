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
    
    private var countLabel: UILabel!
    private var maxValueLabel: UILabel!
    private var minValueLabel: UILabel!
    private var averageLabel: UILabel!
    
    override func loadView() {
        setupView()
        
        setupLabels()
        
        setupLabelsConstraint()
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
        let width: CGFloat = 200
        let height: CGFloat = 30
        
        let labelsCount: Int = 4
        var labels: [UILabel] = []
        
        for i in 0..<labelsCount {
            let newLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            labels.append(newLabel)
            labels[i].textAlignment = .center
             
            view.addSubview(labels[i])
         }
        
        countLabel = labels[0]
        maxValueLabel = labels[1]
        minValueLabel = labels[2]
        averageLabel = labels[3]
    }
    
    private func setupLabelsConstraint() {
        let labelsDistance: CGFloat = 30
        let labels: [UILabel] = [countLabel, maxValueLabel, minValueLabel, averageLabel]
        
        for i in 0..<labels.count {
            labels[i].translatesAutoresizingMaskIntoConstraints = false
            
            let widthConstraint = NSLayoutConstraint(item: labels[i], attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: labels[i].frame.width)
            let heigtConstraint = NSLayoutConstraint(item: labels[i], attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: labels[i].frame.height)
            let horizontalConstraint = NSLayoutConstraint(item: labels[i], attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: labels[i], attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: CGFloat(i) * labelsDistance - 2 * labelsDistance)
            
            let constraints = [widthConstraint, heigtConstraint, horizontalConstraint, verticalConstraint]
            
            view.addConstraints(constraints)
        }
    }
    
    private func showStatistics() {
        if let unwrappedDataSource = dataSource {
            var countString: String = "0"
            var maxString: String = "-"
            var minString: String = "-"
            var averageString: String = "-"
            
            if !unwrappedDataSource.isEmpty() {
                let data = unwrappedDataSource.arrayData()
                
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
