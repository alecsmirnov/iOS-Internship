//
//  RestaurantService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

struct LocationInfo {
    var lat: Float
    var lon: Float
}

struct RestaurantInfo {
    var id: Int
    var name: String
    var description: String
    var address: String
    var location: LocationInfo
    var imagePaths: [String]
    var rating: Float
}

class RestaurantsService {
    private var restaurants: [Restaurant] = []
    
    var isEmpty: Bool {
        return restaurants.isEmpty
    }
    
    var count: Int {
        return restaurants.count
    }
    
    func append(restaurant: Restaurant) {
        restaurants.append(restaurant)
    }
    
    func get(at index: Int) -> RestaurantInfo {
        guard restaurants.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        let restaurant = restaurants[index]
        let locationInfo = LocationInfo(lat: restaurant.location.lat, lon: restaurant.location.lon)
        let imagePaths = restaurant.images.allObjects as! [String]
        
        let restaurantInfo = RestaurantInfo(id: Int(restaurant.id),
                                            name: restaurant.name,
                                            description: restaurant.descriptions,
                                            address: restaurant.address,
                                            location: locationInfo,
                                            imagePaths: imagePaths,
                                            rating: restaurant.rating)
        return restaurantInfo
    }
    
    func save(restaurantInfo: RestaurantInfo) {
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let restaurantEntity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext)!
            let coordinatesEntity = NSEntityDescription.entity(forEntityName: "Coordinates", in: managedContext)!
            let imageEntity = NSEntityDescription.entity(forEntityName: "Image", in: managedContext)!
            
            let coordinates = Coordinates(entity: coordinatesEntity, insertInto: managedContext)
            
            coordinates.lat = restaurantInfo.location.lat
            coordinates.lon = restaurantInfo.location.lon
            
//            let images = NSSet()
//
//            for path in restaurantInfo.imagePaths {
//                let image = Image(entity: imageEntity, insertInto: managedContext)
//                image.path = path
//
//                images.adding(image)
//            }
            
            let restaurant = Restaurant(entity: restaurantEntity, insertInto: managedContext)

            restaurant.id = Int32(restaurantInfo.id)
            restaurant.name = restaurantInfo.name
            restaurant.descriptions = restaurantInfo.description
            restaurant.address = restaurantInfo.address
            restaurant.rating = restaurantInfo.rating
            restaurant.location = coordinates
            //restaurant.images = images
            
            do {
                try managedContext.save()

                self.restaurants.append(restaurant)
            } catch let error as NSError {
                fatalError("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func load() {
        //DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()

            do {
                self.restaurants = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                fatalError("Could not fetch. \(error), \(error.userInfo)")
            }
       // }
    }
}
