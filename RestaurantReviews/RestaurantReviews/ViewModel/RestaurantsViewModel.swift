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
        return displayMode == .all ? restaurantsModel.isEmpty : favoriteRestaurantIds.isEmpty
    }
    
    var rowsCount: Int {
        return displayMode == .all ? restaurantsModel.count : favoriteRestaurantIds.count
    }
    
    weak var delegate: RestaurantsViewModelDelegate?
    
    var displayMode : RestaurantsDisplayMode
    
    private var notificationCenter: NotificationCenter
    
    private var restaurantsModel: RestaurantsModel
    private var favoriteRestaurantIds: FavoriteRestaurantIds
    
    init(restaurantsModel: RestaurantsModel, favoriteRestaurantIds: FavoriteRestaurantIds, displayMode: RestaurantsDisplayMode) {
        self.restaurantsModel = restaurantsModel
        self.favoriteRestaurantIds = favoriteRestaurantIds
        self.displayMode = displayMode
        
        notificationCenter = NotificationCenter()
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
            restaurantInfo = restaurantsModel.get(at: favoriteRestaurantIds.get(at: index))
            break
        }
        
        return CellViewModel(restaurantInfo: restaurantInfo)
    }
    
    func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        var restaurantInfo: RestaurantData!
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
        
        return RestaurantViewModel(restaurantInfo: restaurantInfo, favorite: favorite, notificationCenter: notificationCenter)
    }
    
    func update() {
        restaurantsModel.update()
    }
    
    func removeAll() {
        favoriteRestaurantIds.removeAll()
    }
    
    func userRemoveRestaurantFromFavorites(at index: Int) {
        favoriteRestaurantIds.remove(id: favoriteRestaurantIds.get(at: index))
    }
}

extension RestaurantsViewModel: RestaurantsModelDelegate {   
    func restaurantsModelDelegateReloadData(_ viewController: AnyObject) {
        if let delegate = delegate {
            delegate.restaurantsViewModelDelegateReloadData(viewController)
        }
    }
}
