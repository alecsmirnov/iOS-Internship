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
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var nameTextView: UITextView!
    @IBOutlet var descriptionTextView: UITextView!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
}
