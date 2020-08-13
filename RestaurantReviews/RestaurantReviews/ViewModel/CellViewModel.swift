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
        imageIconData = Data(restaurantInfo.iconData.utf8)
        nameText = restaurantInfo.name
        descriptionText = restaurantInfo.description
    }
}
