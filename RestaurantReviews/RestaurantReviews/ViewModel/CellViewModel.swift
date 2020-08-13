//
//  CellViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    var imagePath: String
    var nameText: String
    var descriptionText: String
    
    init(restaurantInfo: RestaurantInfo) {
        /*
        let imagePaths = restaurantInfo.imagePaths
         
        if let image = imagePaths.first {
            imagePath = image
        }
        else {
            imagePath = ""
        }
        */
        
        imagePath = restaurantInfo.imageIconPath
        nameText = restaurantInfo.name
        descriptionText = restaurantInfo.description
    }
}
