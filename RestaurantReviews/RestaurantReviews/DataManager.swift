////
////  DataManager.swift
////  RestaurantReviews
////
////  Created by Admin on 10.08.2020.
////  Copyright © 2020 Admin. All rights reserved.
////
//
//import UIKit
//import CoreData
//
//enum URLAddresses {
//    static let restaurants = "https://restaurants-f64d7.firebaseio.com/restaurants.json"
//    static let reviews = "https://restaurants-f64d7.firebaseio.com/reviews.json"
//}
//
//class DataManager {
//    var restaurantsService: RestaurantService!
//    
//    var restaurants: [Restaurant] = []
//    var reviews: [NSManagedObject] = []
//    
//    var locations: [Coordinates] = []
//    
//    //var restaurants: [RestaurantJSON] = []
//    //var reviews: [ReviewJSON] = []
//    
//    func getRestaurantsFromServer() {
//        getRestaurants(urlString: URLAddresses.restaurants) { [unowned self] (data) in
//            //self.restaurants = data
//            for elem in data {
//                self.saveRestaurant(elem)
//            }
//        }
//    }
//    
//    func getReviewsFromServer() {
//        getReviews(urlString: URLAddresses.reviews) { [unowned self] (data) in
//            //self.reviews = data
//            for elem in data {
//                self.saveReview(elem)
//            }
//        }
//    }
//    
//    func loadRestaurants() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
//
//        do {
//            restaurants = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
//    
//    func loadReviews() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Review> = Review.fetchRequest()
//
//        do {
//            reviews = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)")
//        }
//    }
//    
//    private func saveRestaurant(_ restaurantJSON: RestaurantJSON) {
//        DispatchQueue.main.async(execute: {
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//            
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let restaurantEntity = NSEntityDescription.entity(forEntityName: "Restaurant", in: managedContext)!
//            let coordinatesEntity = NSEntityDescription.entity(forEntityName: "Coordinates", in: managedContext)!
//            let imageEntity = NSEntityDescription.entity(forEntityName: "Image", in: managedContext)!
//            let restaurant = Restaurant(entity: restaurantEntity, insertInto: managedContext)
//            let coordinates = Coordinates(entity: coordinatesEntity, insertInto: managedContext)
//            //let restaurant = NSManagedObject(entity: restaurantEntity, insertInto: managedContext)
//            //let coordinates = NSManagedObject(entity: coordinatesEntity, insertInto: managedContext)
//            
////            restaurant.setValue(Int32(restaurantJSON.id), forKey: "id")
////            restaurant.setValue(restaurantJSON.name, forKey: "name")
////            restaurant.setValue(restaurantJSON.description, forKey: "descriptions")
////            restaurant.setValue(restaurantJSON.address, forKey: "address")
//            
//            
//            restaurant.id = Int32(restaurantJSON.id)
//            restaurant.name = restaurantJSON.name
//            restaurant.descriptions = restaurantJSON.description
//            restaurant.address = restaurantJSON.address
//
//            coordinates.lat = restaurantJSON.location.lat
//            coordinates.lon = restaurantJSON.location.lon
//            coordinates.restaurant = restaurant
//
//            restaurant.location = coordinates
//            restaurant.rating = restaurantJSON.rating
//            restaurant.favorite = false
////
////            for path in restaurantJSON.imagePaths {
////                let image = Image(entity: imageEntity, insertInto: managedContext)
////
////                image.path = path
////                image.restaurant = restaurant
////
////                restaurant.addToImages(image)
////            }
//            
////            restaurant.id = Int32(restaurantJSON.id)
////            restaurant.name = restaurantJSON.name
////            restaurant.descriptions = restaurantJSON.description
////            restaurant.address = restaurantJSON.address
////
////            coordinates.lat = restaurantJSON.location.lat
////            coordinates.lon = restaurantJSON.location.lon
////            coordinates.restaurant = restaurant
////
////            restaurant.location = coordinates
////            restaurant.rating = restaurantJSON.rating
////            restaurant.favorite = false
////
////            for path in restaurantJSON.imagePaths {
////                let image = Image(entity: imageEntity, insertInto: managedContext)
////
////                image.path = path
////                image.restaurant = restaurant
////
////                restaurant.addToImages(image)
////            }
//
//            do {
//                try managedContext.save()
//
//                self.restaurants.append(restaurant)
//                self.locations.append(coordinates)
//                
//            } catch let error as NSError {
//                print("Could not save. \(error), \(error.userInfo)")
//            }
//        })
//    }
//    
//    private func saveReview(_ reviewJSON: ReviewJSON) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let reviewEntity = NSEntityDescription.entity(forEntityName: "Review", in: managedContext)!
//        let review = Review(entity: reviewEntity, insertInto: managedContext)
//        
//        review.restaurantId = Int32(reviewJSON.restaurantId)
//        review.author = reviewJSON.author
//        review.text = reviewJSON.reviewText
//        review.date = reviewJSON.date
//        
//        do {
//            try managedContext.save()
//            
//            reviews.append(review)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }
//}
