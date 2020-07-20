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
            label.text = cellViewModel.text
            
            if let color = cellViewModel.color {
                label.textColor = TableViewCell.colorToUIColor(color)
            }
            
            textField.text = NumberConverter.toText(cellViewModel.value)
        }
    }
    
    @IBOutlet private var label: UILabel!
    @IBOutlet var textField: UITextField!
    
    private static func colorToUIColor(_ color: Color) -> UIColor {
        return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
}
