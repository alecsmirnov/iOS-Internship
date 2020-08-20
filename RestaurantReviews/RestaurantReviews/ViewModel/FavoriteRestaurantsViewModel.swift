//
//  FavoriteRestaurantsViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 20.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class FavoriteRestaurantsViewModel: RestaurantsViewModel {
    override var isEmpty: Bool {
        return isEmptyFavoriteRestaurants
    }
    
    override var rowsCount: Int {
        return favoriteRestaurantsRowsCount
    }
    
    private var completeFavoriteIds: FavoriteIds
    
    override init(restaurantsModel: RestaurantsModel, favoriteIds: FavoriteIds) {
        completeFavoriteIds = favoriteIds
        
        super.init(restaurantsModel: restaurantsModel, favoriteIds: favoriteIds)
    }
    
    override func cellViewModel(at index: Int) -> CellViewModel {
        //let restaurantData = restaurantsModel.get(at: favoriteIds.get(at: index))
        guard let restaurantData = restaurantsModel.search(by: favoriteIds.get(at: index)) else {
            fatalError("Nonexistent restaurant id")
        }
        
        return CellViewModel(restaurantData: restaurantData)
    }
    
    override func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        //let restaurantData = restaurantsModel.get(at: favoriteIds.get(at: index))
        guard let restaurantData = restaurantsModel.search(by: favoriteIds.get(at: index)) else {
            fatalError("Nonexistent restaurant id")
        }
        
        let favorite = true
        
        return RestaurantViewModel(restaurantData: restaurantData, favorite: favorite, delegate: self)
    }
    
    override func setFilter(text: String) {
        restaurantsModel.load(filterText: text)
        
        favoriteIds = completeFavoriteIds
        
        var ids: [Int] = []
        
        for index in 0..<restaurantsModel.count {
            let id = restaurantsModel.get(at: index).id
            
            ids.append(id)
        }
        
        for index in 0..<completeFavoriteIds.count {
            let restaurantId = completeFavoriteIds.get(at: index)
            
            if !ids.contains(restaurantId) {
                favoriteIds.remove(id: restaurantId)
            }
        }
    }
    
    override func clearFilter() {
        restaurantsModel.load()
        
        favoriteIds = completeFavoriteIds
    }
}
