//
//  CellViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct CellViewModel {
    let mainImagePath: String?
    let nameText: String
    let descriptionText: String
    
    init(restaurantData: RestaurantData) {       
        nameText = restaurantData.name
        descriptionText = restaurantData.description
        
        let imagePaths = restaurantData.imagePaths
        if let firstImagePath = imagePaths.first {
            mainImagePath = firstImagePath
        }
        else {
            mainImagePath = nil
        }
    }
}
