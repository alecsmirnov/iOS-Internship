//
//  RestaurantsViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum RestaurantsDisplayMode {
    case all
    case favorites
}

class RestaurantsViewModel {
    var displayMode : RestaurantsDisplayMode
    
    private var restaurantsModel: RestaurantsModel
    private var favoriteRestaurantIds: FavoriteRestaurantIds
    
    var rowsCount: Int {
        return displayMode == .all ? restaurantsModel.count : favoriteRestaurantIds.count
    }
    
    init(restaurantsModel: RestaurantsModel, favoriteRestaurantIds: FavoriteRestaurantIds, displayMode: RestaurantsDisplayMode) {
        self.restaurantsModel = restaurantsModel
        self.favoriteRestaurantIds = favoriteRestaurantIds
        
        self.displayMode = displayMode
    }
    
    func cellViewModel(at index: Int) -> CellViewModel {
        var restaurantInfo: RestaurantInfo!
        
        switch displayMode {
        case .all:
            restaurantInfo = restaurantsModel.get(at: index)
            break
        case .favorites:
            restaurantInfo = restaurantsModel.get(at: favoriteRestaurantIds.get(at: index))
            break
        }
        
        return CellViewModel(restaurantInfo: restaurantInfo)
    }
    
    func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        var restaurantInfo: RestaurantInfo!
        var favorite = true
        
        switch displayMode {
        case .all:
            restaurantInfo = restaurantsModel.get(at: index)
            favorite = favoriteRestaurantIds.isFavorite(id: restaurantInfo.id)
            break
        case .favorites:
            restaurantInfo = restaurantsModel.get(at: favoriteRestaurantIds.get(at: index))
            break
        }
        
        return RestaurantViewModel(restaurantInfo: restaurantInfo, favorite: favorite, delegate: self)
    }
    
    func update() {
        restaurantsModel.update()
        favoriteRestaurantIds.load()
    }
    
    func userRemoveRestaurantFromFavorites(at index: Int) {
        let id = restaurantsModel.get(at: index).id
        
        favoriteRestaurantIds.remove(id: id)
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
