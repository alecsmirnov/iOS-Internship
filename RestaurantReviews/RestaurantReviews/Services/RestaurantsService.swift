//
//  RestaurantsService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

struct RestaurantInfo {
    var id: Int
    var name: String
    var description: String
    var address: String
    var location: CLLocationCoordinate2D
    var rating: Float
}

class RestaurantsService {
    var isEmpty: Bool {
        return restaurants.isEmpty
    }
    
    var count: Int {
        return restaurants.count
    }
    
    private var restaurants: [Restaurant] = []
    
    func get(at index: Int) -> RestaurantInfo {
        guard restaurants.indices.contains(index) else {
            fatalError("Index is out of range")
        }
        
        let restaurant = restaurants[index]
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.lat),
                                              longitude: CLLocationDegrees(restaurant.lon))
        let restaurantInfo = RestaurantInfo(id: Int(restaurant.id),
                                            name: restaurant.name,
                                            description: restaurant.descriptions,
                                            address: restaurant.address,
                                            location: location,
                                            rating: restaurant.rating)
        return restaurantInfo
    }
    
    func append(restaurantInfo: RestaurantInfo) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let restaurantEntity = NSEntityDescription.entity(forEntityName: Entities.restaurant, in: managedContext) else {
            fatalError("Incorrect entity name: \(Entities.restaurant)")
        }
        
        let restaurant = Restaurant(entity: restaurantEntity, insertInto: managedContext)
        let location = restaurantInfo.location

        restaurant.id = Int32(restaurantInfo.id)
        restaurant.name = restaurantInfo.name
        restaurant.descriptions = restaurantInfo.description
        restaurant.address = restaurantInfo.address
        restaurant.rating = restaurantInfo.rating
        restaurant.lat = Float(location.latitude)
        restaurant.lon = Float(location.longitude)
        
        do {
            restaurants.append(restaurant)
            
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func load(filterText: String = "") {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()

        do {
            restaurants = try managedContext.fetch(fetchRequest)
            
            if !filterText.isEmpty {
                restaurants = restaurants.filter({ (restaurant) -> Bool in
                    let name = restaurant.name
                    let description = restaurant.description
                    
                    return name.contains(filterText) || description.contains(filterText)
                })
            }
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func removeAll() {
        clearEntities(name: Entities.restaurant)
        restaurants.removeAll()
    }
    
    private func clearEntities(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        
        do {
            let entities = try managedContext.fetch(fetchRequest)
            
            for entity in entities {
                let object = entity as! NSManagedObject
                
                managedContext.delete(object)
                
                try managedContext.save()
            }
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    deinit {
        restaurants.removeAll()
    }
}
