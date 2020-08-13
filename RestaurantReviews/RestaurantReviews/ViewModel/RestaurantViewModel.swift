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
    
    private var notificationCenter: NotificationCenter
    
    init(restaurantInfo: RestaurantInfo, favorite: Bool, delegate: RestaurantViewModelDelegate, notificationCenter: NotificationCenter) {
        self.restaurantInfo = restaurantInfo
        self.favorite = favorite
        
        self.delegate = delegate
        
        self.notificationCenter = notificationCenter
        notificationCenter.addObserver(self, selector: #selector(onReceiveMessage(_:)), name: nil, object: nil)
    }
    
    func userChangeFavoriteStatus() {        
        delegate.restaurantViewModelDelegate(self, toFavorite: restaurantInfo.id)
    }
    
    @objc private func onReceiveMessage(_ notification: Notification) {
        favorite = !favorite
    }
}
