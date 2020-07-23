//
//  TableViewCell.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var cellViewModel: CellViewModel! {
        didSet {
            label.text = cellViewModel.valueText
            textView.text = cellViewModel.numberText
            
            if let color = cellViewModel.color {
                label.textColor = UIColor(color)
            }
        }
    }
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var textView: UITextView!
}
