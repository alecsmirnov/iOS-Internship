//
//  AllRestaurantsViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 20.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class AllRestaurantsViewModel: RestaurantsViewModel {
    override var isEmpty: Bool {
        return isEmptyAllRestaurants
    }
    
    override var rowsCount: Int {
        return allRestaurantsRowsCount
    }
    
    override func cellViewModel(at index: Int) -> CellViewModel {
        let restaurantData = restaurantsModel.get(at: index)
        
        return CellViewModel(restaurantData: restaurantData)
    }
    
    override func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        let restaurantData = restaurantsModel.get(at: index)
        let favorite = favoriteIds.isFavorite(id: restaurantData.id)
        
        return RestaurantViewModel(restaurantData: restaurantData, favorite: favorite, delegate: self)
    }
    
    override func setFilter(text: String) {
        restaurantsModel.load(filterText: text)
    }
    
    override func clearFilter() {
        restaurantsModel.load()
    }
}
