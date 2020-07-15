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
        }
    }
    
    @IBOutlet private var label: UILabel!
    
    /*
    func setLabelText(text: String) {
        if let cellModel = tableViewCellViewModel {
            label.text = cellModel.text
        }
    }
     */
}
