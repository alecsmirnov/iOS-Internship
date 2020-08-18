//
//  RestaurantViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class RestaurantViewModel {
    var restaurantInfo: RestaurantData
    var favorite: Bool
    
    var notificationCenter: NotificationCenter
    
    init(restaurantInfo: RestaurantData, favorite: Bool, notificationCenter: NotificationCenter) {
        self.restaurantInfo = restaurantInfo
        self.favorite = favorite
        
        self.notificationCenter = notificationCenter
        //notificationCenter.addObserver(self, selector: #selector(onReceiveMessage(_:)), name: NSNotification.Name(""), object: nil)
    }
    
    func userChangeFavoriteStatus() {                
        favorite = !favorite
    }
    
//    @objc private func onReceiveMessage(_ notification: Notification) {
//        favorite = !favorite
//    }
}
