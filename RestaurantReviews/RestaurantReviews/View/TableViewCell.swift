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
            //imageIconView.image = UIImage(data: cellViewModel.imageData)
            
            imageIconView.getImage(url: cellViewModel.imagePath)
            
            nameLabel.text = cellViewModel.nameText
            descriptionLabel.text = cellViewModel.descriptionText
        }
    }
    
    @IBOutlet var imageIconView: UIImageView!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
