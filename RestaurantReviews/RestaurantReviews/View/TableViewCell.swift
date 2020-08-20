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
            if let mainImagePath = cellViewModel.mainImagePath {
                mainImageView.loadImage(url: mainImagePath)
            }

            nameLabel.text = cellViewModel.nameText
            descriptionLabel.text = cellViewModel.descriptionText
        }
    }
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
