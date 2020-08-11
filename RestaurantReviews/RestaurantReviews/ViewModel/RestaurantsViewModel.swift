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
    
    var rowsCount: Int {
        return restaurantsModel.count
    }
    
    init(restaurantsModel: RestaurantsModel) {
        self.restaurantsModel = restaurantsModel
    }
    
    func cellViewModel(at index: Int) -> CellViewModel {
        return CellViewModel(restaurantInfo: restaurantsModel.get(at: index))
    }
    
    func restaurantViewModel(at index: Int) -> RestaurantViewModel {
        let restaurantInfo = restaurantsModel.get(at: index)
        let favorite = restaurantsModel.isFavorite(id: restaurantInfo.id)
        
        return RestaurantViewModel(restaurantInfo: restaurantInfo, favorite: favorite, delegate: self)
    }
    
    func update() {
        restaurantsModel.update()
    }
}

extension RestaurantsViewModel: RestaurantViewModelDelegate {
    func restaurantViewModelDelegate(_ viewModel: AnyObject, toFavorite id: Int) {
        restaurantsModel.favoriteReverse(id: id)
    }
}
