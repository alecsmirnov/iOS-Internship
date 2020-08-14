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
    
    func load(filterText: String = "") {
        restaurants.load(filterText: filterText)
    }
    
    func clear() {
        restaurants.clear()
    }
    
    func download() {
        // What a mess
        if restaurants.isEmpty {
            getRestaurantsFrom(url: URLStrings.restaurants) { [unowned self] (jsonData) in
                for elem in jsonData {
                    let locationInfo = LocationInfo(lat: elem.location.lat, lon: elem.location.lon)

                    let restaurantInfo = RestaurantInfo(id: elem.id,
                                                        name: elem.name,
                                                        description: elem.description,
                                                        address: elem.address,
                                                        location: locationInfo,
                                                        iconData: "",
                                                        imagesData: [],
                                                        rating: elem.rating)

                    self.save(restaurantInfo: restaurantInfo)
                    
                    if let iconPath = elem.imagePaths.first {
                        getImageFrom(url: iconPath) { [unowned self] (data) in
                            self.restaurants.setIconData(data.base64EncodedString(), toRestaurant: restaurantInfo.id)
                        }
                    }
                    
                    // "Mutating a managed object after it has been removed from its context" on get() after clear()
                    for path in elem.imagePaths.dropFirst() {
                        getImageFrom(url: path) { [unowned self] (data) in
                            self.restaurants.addImageData(data.base64EncodedString(), toRestaurant: restaurantInfo.id)
                        }
                    }
                }
                
                //self.restaurants.load()
            }
        }
    }
    
    private func checkNetworkServices() {
        
    }
}
