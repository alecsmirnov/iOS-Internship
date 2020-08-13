//
//  TableViewCell.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum TextViewRowsCount {
    static let name        = 2
    static let description = 3
}

class TableViewCell: UITableViewCell {
    var cellViewModel: CellViewModel! {
        didSet {
            // Setup Image
            nameTextView.text = cellViewModel.nameText
            descriptionTextView.text = cellViewModel.descriptionText
        }
    }
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var nameTextView: UITextView!
    @IBOutlet private var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adjustTextViewHeight(textView: nameTextView, rowsCountMax: TextViewRowsCount.name)
        adjustTextViewHeight(textView: descriptionTextView, rowsCountMax: TextViewRowsCount.description)
    }
    
    private func adjustTextViewHeight(textView: UITextView, rowsCountMax: Int) {
        textView.textContainer.maximumNumberOfLines = rowsCountMax
        textView.textContainer.lineBreakMode = .byWordWrapping
    }
}
