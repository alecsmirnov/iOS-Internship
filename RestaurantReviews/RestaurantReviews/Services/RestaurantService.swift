//
//  RestaurantService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

private enum Entities {
    static let restaurant  = "Restaurant"
    static let coordinates = "Coordinates"
    static let image       = "Image"
}

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
    var iconData: String  // Temp
    var imagesData: [String]
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
    
    func append(restaurant: Restaurant) {
        restaurants.append(restaurant)
    }
    
    func get(at index: Int) -> RestaurantInfo {
        guard restaurants.indices.contains(index) else {
            fatalError("Index is out of range")
        }
        
        let restaurant = restaurants[index]
        let locationInfo = LocationInfo(lat: restaurant.location.lat, lon: restaurant.location.lon)
        let imagesData = restaurant.images.map { (image) -> String in
            guard let image = image as? Image else {
                fatalError("Image is empty")
            }
            
            return image.data
        }
        
        let restaurantInfo = RestaurantInfo(id: Int(restaurant.id),
                                            name: restaurant.name,
                                            description: restaurant.descriptions,
                                            address: restaurant.address,
                                            location: locationInfo,
                                            iconData: restaurant.iconData, // Temp
                                            imagesData: imagesData,
                                            rating: restaurant.rating)
        return restaurantInfo
    }
    
    func save(restaurantInfo: RestaurantInfo) {
        // Why is it the main thread?
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let restaurantEntity = NSEntityDescription.entity(forEntityName: Entities.restaurant, in: managedContext) else {
                fatalError("Incorrect entity name: \(Entities.restaurant)")
            }
            
            guard let coordinatesEntity = NSEntityDescription.entity(forEntityName: Entities.coordinates, in: managedContext) else {
                fatalError("Incorrect entity name: \(Entities.coordinates)")
            }
            
            guard let imageEntity = NSEntityDescription.entity(forEntityName: Entities.image, in: managedContext) else {
                fatalError("Incorrect entity name: \(Entities.image)")
            }
            
            let coordinates = Coordinates(entity: coordinatesEntity, insertInto: managedContext)
            
            coordinates.lat = restaurantInfo.location.lat
            coordinates.lon = restaurantInfo.location.lon
            
            let restaurant = Restaurant(entity: restaurantEntity, insertInto: managedContext)

            restaurant.id = Int32(restaurantInfo.id)
            restaurant.name = restaurantInfo.name
            restaurant.descriptions = restaurantInfo.description
            restaurant.address = restaurantInfo.address
            restaurant.rating = restaurantInfo.rating
            restaurant.location = coordinates
            restaurant.iconData = restaurantInfo.iconData  // Temp

            for data in restaurantInfo.imagesData {
                let image = Image(entity: imageEntity, insertInto: managedContext)
                image.data = data

                restaurant.addToImages(image)
            }
            
            do {
                self.restaurants.append(restaurant)
                
                try managedContext.save()
            } catch let error as NSError {
                fatalError("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func load(filterText: String = "") {
        // And this main thread
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()

            do {
                self.restaurants = try managedContext.fetch(fetchRequest)
                
                if !filterText.isEmpty {
                    self.restaurants = self.restaurants.filter({ (restaurant) -> Bool in
                        let name = restaurant.name
                        let description = restaurant.description
                        
                        return name.contains(filterText) || description.contains(filterText)
                    })
                }
            } catch let error as NSError {
                fatalError("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func setIconData(_ iconData: String, toRestaurant id: Int) {
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            
            do {
                if let firstIndex = self.restaurants.firstIndex(where: { (restaurant) -> Bool in
                    return restaurant.id == id
                }) {
                    self.restaurants[firstIndex].iconData = iconData
                    
                    let entities = try managedContext.fetch(fetchRequest)
                    if let firstIndex = entities.firstIndex(where: { (restaurant) -> Bool in
                        return restaurant.id == id
                    }) {
                        entities[firstIndex].iconData = iconData
                    }
                    
                    try managedContext.save()
                }
            }
            catch let error as NSError {
                fatalError("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func addImageData(_ imageData: String, toRestaurant id: Int) {
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
            
            guard let imageEntity = NSEntityDescription.entity(forEntityName: Entities.image, in: managedContext) else {
                fatalError("Incorrect entity name: \(Entities.image)")
            }
            
            let image = Image(entity: imageEntity, insertInto: managedContext)
            image.data = imageData
            
            do {
                if let firstIndex = self.restaurants.firstIndex(where: { (restaurant) -> Bool in
                    return restaurant.id == id
                }) {
                    self.restaurants[firstIndex].addToImages(image)
                    
                    let entities = try managedContext.fetch(fetchRequest)
                    if let firstIndex = entities.firstIndex(where: { (restaurant) -> Bool in
                        return restaurant.id == id
                    }) {
                        entities[firstIndex].addToImages(image)
                    }
                    
                    try managedContext.save()
                }
            }
            catch let error as NSError {
                fatalError("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func clear() {
        clearEntities(name: Entities.restaurant)
        clearEntities(name: Entities.coordinates)
        clearEntities(name: Entities.image)
        
        restaurants.removeAll()
    }
    
    private func clearEntities(name: String) {
        DispatchQueue.main.async {
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
    }
    
    deinit {
        restaurants.removeAll()
    }
}
