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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
    
    private func setupLabel() {
        let width: CGFloat = 100
        let height: CGFloat = 30
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //label.textAlignment = .center
        
        addSubview(label)
    }
}
