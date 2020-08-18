//
//  CellViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    var mainImagePath: String?
    var nameText: String
    var descriptionText: String
    
    init(restaurantInfo: RestaurantData) {       
        nameText = restaurantInfo.name
        descriptionText = restaurantInfo.description
        
        let imagePaths = restaurantInfo.imagePaths
        if let firstImagePath = imagePaths.first {
            mainImagePath = firstImagePath
        }
    }
}
