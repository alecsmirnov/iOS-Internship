//
//  TableViewCell.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet private var label: UILabel!
    
    func setLabelText(text: String) {
        label.text = text
    }
}
