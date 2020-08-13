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
            setupImageFrom(url: cellViewModel.imagePath)
            
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
    
    private func setupImageFrom(url string: String) {
        if !string.isEmpty {
            getImageFrom(url: string) { [unowned self] (data) in
                DispatchQueue.main.async {
                    self.imageIconView.image = UIImage(data: data)
                }
            }
        }
    }
}
