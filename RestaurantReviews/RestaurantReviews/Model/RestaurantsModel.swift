//
//  RestaurantsModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

private enum URLStrings {
    static let restaurants = "https://restaurants-f64d7.firebaseio.com/restaurants.json"
    static let reviews     = "https://restaurants-f64d7.firebaseio.com/reviews.json"
}

class RestaurantsModel {
    //var updateInterval: Float = 0
    
    var isEmpty: Bool {
        return restaurants.isEmpty
    }
    
    var count: Int {
        return restaurants.count
    }
    
    private var restaurants: RestaurantsService
    
    init() {
        restaurants = RestaurantsService()
    }
    
    func get(at index: Int) -> RestaurantInfo {
        return restaurants.get(at: index)
    }
    
    func save(restaurantInfo: RestaurantInfo) {
        restaurants.save(restaurantInfo: restaurantInfo)
    }
    
    func load() {
        restaurants.load()
    }
    
    func clear() {
        restaurants.clear()
    }
    
    func update() {
        // Temporarily. For tests
        load()
        
        //clear()
        
        if isEmpty {
            getRestaurants(urlString: URLStrings.restaurants) { [unowned self] (jsonData) in
                for elem in jsonData {
                    let locationInfo = LocationInfo(lat: elem.location.lat, lon: elem.location.lon)
                    let restaurantInfo = RestaurantInfo(id: elem.id,
                                                        name: elem.name,
                                                        description: elem.description,
                                                        address: elem.address,
                                                        location: locationInfo,
                                                        imagePaths: elem.imagePaths,
                                                        rating: elem.rating)
                    
                    self.save(restaurantInfo: restaurantInfo)
                }
            }
        }
    }
    
    private func checkNetworkServices() {
        
    }
}
