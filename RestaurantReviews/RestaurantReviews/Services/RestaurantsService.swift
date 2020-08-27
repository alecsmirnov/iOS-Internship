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

struct ReviewData {
    let restaurantId: Int
    let author: String
    let date: String
    let reviewText: String
}

struct RestaurantData {
    let id: Int
    let name: String
    let description: String
    let address: String
    let location: CLLocationCoordinate2D
    let imagePaths: [String]
    let rating: Float
    
    var reviews: [ReviewData] = []
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

        return restaurantToRestaurantData(restaurant: restaurants[index])
    }
    
    func search(by restaurantId: Int) -> RestaurantData? {
        if let firstIndex = restaurants.firstIndex(where: { (restaurant) -> Bool in
            return restaurantId == Int(restaurant.id)
        }) {
            return restaurantToRestaurantData(restaurant: restaurants[firstIndex])
        }
        
        return nil
    }
    
    func getData() -> [RestaurantData] {
        return restaurants.map { (restaurant) -> RestaurantData in
            return restaurantToRestaurantData(restaurant: restaurant)
        }
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
    
    func append(_ reviewData: ReviewData) {
        guard let firstIndex = restaurants.firstIndex(where: { (restaurant) -> Bool in
            return restaurant.id == reviewData.restaurantId
        }) else { return }
        
        DispatchQueue.main.async { [unowned self] in
            if let managedContext = self.managedContext {
                let restaurant = self.restaurants[firstIndex]
                
                guard let reviewEntity = NSEntityDescription.entity(forEntityName: Entities.review, in: managedContext) else {
                    fatalError("Incorrect entity name: \(Entities.review)")
                }
                
                let review = Review(entity: reviewEntity, insertInto: managedContext)
                
                review.restaurantId = Int32(reviewData.restaurantId)
                review.author = reviewData.author
                review.date = reviewData.date
                review.reviewText = reviewData.reviewText
                
                do {
                    restaurant.addToReviews(review)
                    
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
    
    private func restaurantToRestaurantData(restaurant: Restaurant) -> RestaurantData {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(restaurant.location.lat),
                                              longitude: CLLocationDegrees(restaurant.location.lon))
        
        let imagePaths = restaurant.images.map { (image) -> String in
            guard let image = image as? Image else {
                fatalError("Image is empty")
            }
            
            return image.path
        }
        
        let reviewsData = restaurant.reviews.map { (review) -> ReviewData in
            guard let review = review as? Review else {
                fatalError("Review is empty")
            }
            
            let reviewData = ReviewData(restaurantId: Int(review.restaurantId),
                                        author: review.author,
                                        date: review.date,
                                        reviewText: review.reviewText)
            
            return reviewData
        }
        
        var restaurantData = RestaurantData(id: Int(restaurant.id),
                                            name: restaurant.name,
                                            description: restaurant.descriptionText,
                                            address: restaurant.address,
                                            location: location,
                                            imagePaths: imagePaths,
                                            rating: restaurant.rating)
        
        restaurantData.reviews = reviewsData
        
        return restaurantData
    }
    
    deinit {
        restaurants.removeAll()
    }
}
