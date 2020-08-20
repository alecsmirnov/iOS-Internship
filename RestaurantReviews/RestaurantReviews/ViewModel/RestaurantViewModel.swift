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
    
    private(set) var favorite: Bool
    
    private var restaurantData: RestaurantData
    
    private let notificationCenter = NotificationCenter.default
    
    private weak var delegate: RestaurantViewModelDelegate?
    
    init(restaurantData: RestaurantData, favorite: Bool, delegate: RestaurantViewModelDelegate) {
        self.restaurantData = restaurantData
        self.favorite = favorite
        self.delegate = delegate
    }
    
    func switchFavoriteStatus() {
        favorite = !favorite
    }
    
    func userChangeFavoriteStatus() {
        switchFavoriteStatus()
        
        if let delegate = delegate {
            delegate.restaurantViewModelDelegate(self, changeFavoriteStatus: id)
        }
    }
    
    func addObserver(_ observer: Any, selector: Selector, name: NSNotification.Name?) {
        notificationCenter.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    func removeObserver(_ observer: Any) {
        notificationCenter.removeObserver(observer)
    }
    
    func post(name: NSNotification.Name) {
        notificationCenter.post(name: name, object: nil)
    }
}
