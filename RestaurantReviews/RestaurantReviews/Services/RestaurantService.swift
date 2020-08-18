//
//  RestaurantService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

struct RestaurantData {
    var id: Int
    var name: String
    var description: String
    var address: String
    var location: CLLocationCoordinate2D
    var imagePaths: [String]
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
    private var managedContext: NSManagedObjectContext?
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func get(at index: Int) -> RestaurantData {
        guard restaurants.indices.contains(index) else {
            fatalError("Index is out of range")
        }
        
        let restaurant = restaurants[index]
        
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.location.lat),
                                              longitude: CLLocationDegrees(restaurant.location.lon))
        
        let imagePaths = restaurant.images.map { (image) -> String in
            guard let image = image as? Image else {
                fatalError("Image is empty")
            }
            
            return image.path
        }
        
        let restaurantData = RestaurantData(id: Int(restaurant.id),
                                            name: restaurant.name,
                                            description: restaurant.descriptionText,
                                            address: restaurant.address,
                                            location: location,
                                            imagePaths: imagePaths,
                                            rating: restaurant.rating)
        return restaurantData
    }
    
    func append(_ restaurantData: RestaurantData) {
        DispatchQueue.main.async { [unowned self] in
            if let managedContext = self.managedContext {
                guard let restaurantEntity = NSEntityDescription.entity(forEntityName: Entities.restaurant, in: managedContext) else {
                    fatalError("Incorrect entity name: \(Entities.restaurant)")
                }
                
                guard let locationEntity = NSEntityDescription.entity(forEntityName: Entities.location, in: managedContext) else {
                    fatalError("Incorrect entity name: \(Entities.location)")
                }
                
                guard let imageEntity = NSEntityDescription.entity(forEntityName: Entities.image, in: managedContext) else {
                    fatalError("Incorrect entity name: \(Entities.image)")
                }
                
                let location = Location(entity: locationEntity, insertInto: managedContext)
                
                location.lat = Float(restaurantData.location.latitude)
                location.lon = Float(restaurantData.location.longitude)
                
                let restaurant = Restaurant(entity: restaurantEntity, insertInto: managedContext)

                restaurant.id = Int32(restaurantData.id)
                restaurant.name = restaurantData.name
                restaurant.descriptionText = restaurantData.description
                restaurant.address = restaurantData.address
                restaurant.rating = restaurantData.rating
                restaurant.location = location

                for path in restaurantData.imagePaths {
                    let image = Image(entity: imageEntity, insertInto: managedContext)
                    image.path = path

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
    }
    
    func replace(_ restaurants: [RestaurantData]) {
        removeAll()
        
        for restaurantData in restaurants {
            append(restaurantData)
        }
    }
    
    func load(filterText: String = "") {
        if let managedContext = self.managedContext {
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
    
    func removeAll() {
        clearEntities(name: Entities.restaurant)
        clearEntities(name: Entities.location)
        clearEntities(name: Entities.image)
        
        restaurants.removeAll()
    }
    
    private func clearEntities(name: String) {
        DispatchQueue.main.async {
            if let managedContext = self.managedContext {
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
    }
    
    deinit {
        restaurants.removeAll()
    }
}
