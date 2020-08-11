//
//  RestaurantViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RestaurantViewModel {
    var restaurantInfo: RestaurantInfo
    var favorite: Bool
    
    private weak var delegate: RestaurantViewModelDelegate!
    
    init(restaurantInfo: RestaurantInfo, favorite: Bool, delegate: RestaurantViewModelDelegate) {
        self.restaurantInfo = restaurantInfo
        self.favorite = favorite
        self.delegate = delegate
    }
    
    func userChangeFavoriteStatus() {
        favorite = !favorite
        
        delegate.restaurantViewModelDelegate(self, toFavorite: restaurantInfo.id)
    }
}
