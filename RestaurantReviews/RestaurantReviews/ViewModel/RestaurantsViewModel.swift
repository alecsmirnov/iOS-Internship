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
    
    var displayMode : RestaurantsDisplayMode
    
    private var timeCheck: TimeCheck
    
    private var notificationCenter: NotificationCenter
    
    private var restaurantsModel: RestaurantsModel
    private var favoriteRestaurantIds: FavoriteRestaurantIds
    
    init(restaurantsModel: RestaurantsModel, favoriteRestaurantIds: FavoriteRestaurantIds, displayMode: RestaurantsDisplayMode) {
        self.restaurantsModel = restaurantsModel
        self.favoriteRestaurantIds = favoriteRestaurantIds
        
        self.displayMode = displayMode
        
        notificationCenter = NotificationCenter()
        
        timeCheck = TimeCheck()
    }
    
    func setFilter(text: String) {
        restaurantsModel.load(filterText: text)
    }
    
    func clearFilter() {
        restaurantsModel.load()
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
        
        return RestaurantViewModel(restaurantInfo: restaurantInfo, favorite: favorite, delegate: self, notificationCenter: notificationCenter)
    }
    
    func setUpdateTime(second: TimeInterval, minute: TimeInterval, hour: TimeInterval, day: TimeInterval) {
        timeCheck.set(second: second, minute: minute, hour: hour, day: day)
    }
    
    func update() {
        if timeCheck.isUp() {
            //restaurantsModel.clear()
            restaurantsModel.download()
            restaurantsModel.load()
            
            favoriteRestaurantIds.clear()
            favoriteRestaurantIds.load()
        }
    }
    
    func userRemoveRestaurantFromFavorites(at index: Int) {
        favoriteRestaurantIds.remove(id: favoriteRestaurantIds.get(at: index))
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
        
        //notificationCenter.post(name: NSNotification.Name(""), object: nil)
    }
}
