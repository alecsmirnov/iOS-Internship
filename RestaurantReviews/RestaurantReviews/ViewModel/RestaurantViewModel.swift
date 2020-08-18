//
//  RestaurantViewModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import CoreLocation

class RestaurantViewModel {
    var id: Int {
        return restaurantData.id
    }
    
    var name: String {
        return restaurantData.name
    }
    
    var description: String {
        return restaurantData.description
    }
    
    var address: String {
        return restaurantData.address
    }
    
    var location: CLLocationCoordinate2D {
        return restaurantData.location
    }
    
    var mainImagePath: String? {
        if let firstImage = restaurantData.imagePaths.first {
            return firstImage
        }
        
        return nil
    }
    
    var imagePaths: [String] {
        return Array(restaurantData.imagePaths.dropFirst())
    }
    
    var rating: String {
        return String(restaurantData.rating)
    }
    
    var favorite: Bool
    
    var notificationCenter: NotificationCenter
    
    private var restaurantData: RestaurantData
    
    init(restaurantData: RestaurantData, favorite: Bool, notificationCenter: NotificationCenter) {
        self.restaurantData = restaurantData
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
