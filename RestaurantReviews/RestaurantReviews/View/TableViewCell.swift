//
//  TableViewCell.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    var cellViewModel: CellViewModel! {
        didSet {
            //mainImageView
            nameTextView.text = cellViewModel.nameText
            descriptionTextView.text = cellViewModel.descriptionText
        }
    }
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var nameTextView: UITextView!
    @IBOutlet private var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameTextView.textContainer.maximumNumberOfLines = 2
        nameTextView.textContainer.lineBreakMode = .byWordWrapping
        
        descriptionTextView.textContainer.maximumNumberOfLines = 3
        descriptionTextView.textContainer.lineBreakMode = .byWordWrapping
    }
}
