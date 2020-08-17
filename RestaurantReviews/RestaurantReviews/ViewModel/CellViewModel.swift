//
//  CellViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    var imageIconData: Data
    var nameText: String
    var descriptionText: String
    
    init(restaurantInfo: RestaurantInfo) {
        imageIconData = Data()
        
        let imagesData = restaurantInfo.imagesData
        
        if let imageData = imagesData.first {
            if let data = Data(base64Encoded: imageData) {
                imageIconData = data
            }
        }

        nameText = restaurantInfo.name
        descriptionText = restaurantInfo.description
    }
}
