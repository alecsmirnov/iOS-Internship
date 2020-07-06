//
//  TableViewCell.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    private var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label = UILabel()
        
        contentView.addSubview(label)
    }
    
    func setLabelText(text: String) {
        if let unwrappedLabel = label {
            unwrappedLabel.text = text
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
