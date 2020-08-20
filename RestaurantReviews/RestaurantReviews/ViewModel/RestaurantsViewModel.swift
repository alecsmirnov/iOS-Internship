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
    var isEmpty: Bool {
        return displayMode == .all ? restaurantsModel.isEmpty : favoriteIds.isEmpty
    }
    
    var rowsCount: Int {
        return displayMode == .all ? restaurantsModel.count : favoriteIds.count
    }
    
    var displayMode : RestaurantsDisplayMode
    
    private var restaurantsModel: RestaurantsModel
    private var favoriteIds: FavoriteIds
    
    init(restaurantsModel: RestaurantsModel, favoriteIds: FavoriteIds, displayMode: RestaurantsDisplayMode) {
        self.restaurantsModel = restaurantsModel
        self.favoriteIds = favoriteIds
        self.displayMode = displayMode
    }
    
    func setFilter(text: String) {
        restaurantsModel.load(filterText: text)
    }
    
    func clearFilter() {
        restaurantsModel.load()
    }
    
    func cellViewModel(at index: Int) -> CellViewModel {
        var restaurantInfo: RestaurantData!
        
        switch displayMode {
        case .all:
            restaurantInfo = restaurantsModel.get(at: index)
            break
        case .favorites:
            restaurantInfo = restaurantsModel.get(at: favoriteIds.get(at: index))
            break
        }
        
        return CellViewModel(restaurantInfo: restaurantInfo)
    }
    
    func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        var restaurantData: RestaurantData!
        var favorite = true
        
        switch displayMode {
        case .all:
            restaurantData = restaurantsModel.get(at: index)
            favorite = favoriteIds.isFavorite(id: restaurantData.id)
            break
        case .favorites:
            restaurantData = restaurantsModel.get(at: favoriteIds.get(at: index))
            break
        }
        
        return RestaurantViewModel(restaurantData: restaurantData, favorite: favorite, delegate: self)
    }
    
    func update(completionHandler: @escaping () -> ()) {
        restaurantsModel.update(completionHandler: completionHandler)
    }
    
    func removeAll() {
        favoriteIds.removeAll()
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
