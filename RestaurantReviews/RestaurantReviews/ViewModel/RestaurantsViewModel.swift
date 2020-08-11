//
//  RestaurantsViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RestaurantsViewModel {
    private var restaurantsModel: RestaurantsModel
    private var favoriteRestaurantIds: FavoriteRestaurantIds
    
    var rowsCount: Int {
        return restaurantsModel.count
    }
    
    init(restaurantsModel: RestaurantsModel, favoriteRestaurantIds: FavoriteRestaurantIds) {
        self.restaurantsModel = restaurantsModel
        self.favoriteRestaurantIds = favoriteRestaurantIds
    }
    
    func cellViewModel(at index: Int) -> CellViewModel {
        return CellViewModel(restaurantInfo: restaurantsModel.get(at: index))
    }
    
    func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        let restaurantInfo = restaurantsModel.get(at: index)
        let favorite = favoriteRestaurantIds.isFavorite(id: restaurantInfo.id)
        
        return RestaurantViewModel(restaurantInfo: restaurantInfo, favorite: favorite, delegate: self)
    }
    
    func update() {
        restaurantsModel.update()
        favoriteRestaurantIds.load()
    }
}

extension RestaurantsViewModel: RestaurantViewModelDelegate {
    func restaurantViewModelDelegate(_ viewModel: AnyObject, toFavorite id: Int) {
        let favorite = favoriteRestaurantIds.isFavorite(id: id)
        
        if favorite {
            favoriteRestaurantIds.remove(id: id)
        }
        else {
            favoriteRestaurantIds.append(id: id)
        }
    }
}
