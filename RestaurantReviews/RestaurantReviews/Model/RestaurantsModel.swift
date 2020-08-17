//
//  RestaurantsModel.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import CoreLocation

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
    
    private var timeCheck: TimeCheck
    private var restaurants: RestaurantsService
    
    init() {
        restaurants = RestaurantsService()
        timeCheck = TimeCheck()
    }
    
    func get(at index: Int) -> RestaurantInfo {
        return restaurants.get(at: index)
    }
    
    func append(restaurantInfo: RestaurantInfo) {
        restaurants.append(restaurantInfo)
    }
    
    func load(filterText: String = "") {
        restaurants.load(filterText: filterText)
    }
    
    func removeAll() {
        restaurants.removeAll()
    }
    
    func setUpdateTime(second: TimeInterval, minute: TimeInterval, hour: TimeInterval, day: TimeInterval) {
        timeCheck.set(second: second, minute: minute, hour: hour, day: day)
    }
    
    func download() {
        getRestaurantsFrom(url: URLStrings.restaurants) { [unowned self] (jsonData) in
            var restaurants: [RestaurantInfo] = []
            
            for elem in jsonData {
                let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(elem.location.lat),
                                                      longitude: CLLocationDegrees(elem.location.lon))

                let restaurantInfo = RestaurantInfo(id: elem.id,
                                                    name: elem.name,
                                                    description: elem.description,
                                                    address: elem.address,
                                                    location: location,
                                                    imagesData: [],
                                                    rating: elem.rating)
                
                restaurants.append(restaurantInfo)
            }
            
            self.restaurants.removeAll()
            self.restaurants.replace(restaurants)
            
            for elem in jsonData {
                for path in elem.imagePaths {
                    getImageFrom(url: path) { [unowned self] (data) in
                        self.restaurants.addImageData(data.base64EncodedString(), toRestaurant: elem.id)
                    }
                }
            }
        }
    }
    
    func update() {
        if timeCheck.isUp() {
            timeCheck.reset()
            
            print("Update")
            download()
        }
    }
    
    private func checkNetworkServices() {
        
    }
}
