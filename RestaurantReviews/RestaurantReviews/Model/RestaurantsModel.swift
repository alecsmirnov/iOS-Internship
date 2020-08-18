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
    
    weak var delegate: RestaurantsModelDelegate?
    
    private var restaurants: RestaurantsService
    private var timeCheck: TimeCheck
    
    init() {
        restaurants = RestaurantsService()
        timeCheck = TimeCheck()
    }
    
    func get(at index: Int) -> RestaurantData {
        return restaurants.get(at: index)
    }
    
    func append(restaurantInfo: RestaurantData) {
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
    
    func getRestaurants() {
        if Networking.isConnectedToNetwork() {
            Networking.getData(url: URLStrings.restaurants) { [unowned self] (data) in
                do {
                    let restaurantsData = try JSONDecoder().decode([Networking.Restaurant].self, from: data)
                    var restaurants: [RestaurantData] = []
                    
                    for elem in restaurantsData {
                        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(elem.location.lat),
                                                              longitude: CLLocationDegrees(elem.location.lon))

                        let restaurantData = RestaurantData(id: elem.id,
                                                            name: elem.name,
                                                            description: elem.description,
                                                            address: elem.address,
                                                            location: location,
                                                            imagePaths: elem.imagePaths,
                                                            rating: elem.rating)
                        
                        restaurants.append(restaurantData)
                    }
                    
                    self.restaurants.removeAll()
                    self.restaurants.replace(restaurants)
                    
                    if let delegate = self.delegate {
                        delegate.restaurantsModelDelegateReloadData(self)
                    }
                } catch {
                    fatalError("JSON error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func update() {
        if timeCheck.isUp() {
            getRestaurants()
            
            timeCheck.reset()
        }
    }
}
