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
        //setupLabelConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
    
    private func setupLabel() {
        let offsetX: CGFloat = 40
        let offsetY: CGFloat = 5
        
        label = UILabel(frame: CGRect(x: offsetX, y: offsetY, width: frame.width - offsetX, height: frame.height - offsetY))
        
        label.textAlignment = .center
        
        addSubview(label)
    }
    
    /*
    private func setupLabelConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraint = NSLayoutConstraint(item: label!, attribute: .centerX, relatedBy: .equal, toItem: contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: label!, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)

        let constraints = [horizontalConstraint, verticalConstraint]

        contentView.addConstraints(constraints)
    }
    */
}
