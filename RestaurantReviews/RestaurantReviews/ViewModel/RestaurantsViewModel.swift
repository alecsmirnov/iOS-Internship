//
//  RestaurantsViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RestaurantsViewModel {
    var isEmpty: Bool {
        fatalError("This method must be overridden!")
    }
    
    var isEmptyAllRestaurants: Bool {
        return restaurantsModel.isEmpty
    }
    
    var isEmptyFavoriteRestaurants: Bool {
        return favoriteIds.isEmpty
    }
    
    var rowsCount: Int {
        fatalError("This method must be overridden!")
    }
    
    var allRestaurantsRowsCount: Int {
        return restaurantsModel.count
    }
    
    var favoriteRestaurantsRowsCount: Int {
        return favoriteIds.count
    }
    
    internal var restaurantsModel: RestaurantsModel
    internal var favoriteIds: FavoriteIds
    
    init(restaurantsModel: RestaurantsModel, favoriteIds: FavoriteIds) {
        self.restaurantsModel = restaurantsModel
        self.favoriteIds = favoriteIds
    }
    
    func cellViewModel(at index: Int) -> CellViewModel {
        fatalError("This method must be overridden!")
    }
    
    func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        fatalError("This method must be overridden!")
    }
    
    func setFilter(text: String) {
        fatalError("This method must be overridden!")
    }
    
    func clearFilter() {
        fatalError("This method must be overridden!")
    }
    
    func update(completionHandler: @escaping () -> ()) {
        restaurantsModel.update(completionHandler: completionHandler)
    }
    
    func userRemoveRestaurantFromFavorites(at index: Int) {
        favoriteIds.remove(id: favoriteIds.get(at: index))
    }
}

extension RestaurantsViewModel: RestaurantViewModelDelegate {
    func restaurantViewModelDelegate(_ viewController: AnyObject, changeFavoriteStatus restaurantId: Int) {
        let favorite = favoriteIds.isFavorite(id: restaurantId)
        
        if favorite {
            favoriteIds.remove(id: restaurantId)
        }
        else {
            favoriteIds.append(id: restaurantId)
        }
    }
}
