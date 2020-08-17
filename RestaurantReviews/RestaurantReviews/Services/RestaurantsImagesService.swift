//
//  RestaurantsImagesService.swift
//  RestaurantReviews
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

struct RestaurantImagesInfo {
    var restaurantId: Int
    var imagesData: [String]
}

class RestaurantsImagesService {
    var isEmpty: Bool {
        return restaurantsImages.isEmpty
    }
    
    var count: Int {
        return restaurantsImages.count
    }
    
    // Replace with Dictionary
    private var restaurantsImages: [RestaurantImages] = []
    
    func get(at restaurantId: Int) -> RestaurantImagesInfo? {
        guard let firstIndex = restaurantsImages.firstIndex(where: { (restaurantImages) -> Bool in
            return restaurantImages.restaurantId == restaurantId
        }) else {
            return nil
        }
        
        let restaurantImages = restaurantsImages[firstIndex]
        
        let restaurantId = Int(restaurantImages.restaurantId)
        let imagesArray = restaurantImages.images.allObjects
        let imagesData = imagesArray.map { (image) -> String in
            return (image as! Image).data
        }
        
        return RestaurantImagesInfo(restaurantId: restaurantId, imagesData: imagesData)
    }
    
    func append(data: String, by restaurantId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let restaurantImagesEntity = NSEntityDescription.entity(forEntityName: Entities.restaurantImages, in: managedContext) else {
            fatalError("Incorrect entity name: \(Entities.restaurantImages)")
        }
        
        guard let imageEntity = NSEntityDescription.entity(forEntityName: Entities.image, in: managedContext) else {
            fatalError("Incorrect entity name: \(Entities.image)")
        }
        
        do {
            let image = Image(entity: imageEntity, insertInto: managedContext)
            image.data = data
            
            if let firstIndex = restaurantsImages.firstIndex(where: { (restaurantImages) -> Bool in
                return restaurantImages.restaurantId == restaurantId
            }) {
                let restaurantImages = restaurantsImages[firstIndex]
                restaurantImages.addToImages(image)
            }
            else {
                let restaurantImages = RestaurantImages(entity: restaurantImagesEntity, insertInto: managedContext)
                restaurantImages.restaurantId = Int32(restaurantId)
                restaurantImages.addToImages(image)
                
                restaurantsImages.append(restaurantImages)
            }
            
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
        let fetchRequest: NSFetchRequest<RestaurantImages> = RestaurantImages.fetchRequest()

        do {
            restaurantsImages = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func remove(at restaurantId: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.restaurantImages)
        
        do {
            let entities = try managedContext.fetch(fetchRequest)
            
            if let firstIndex = entities.firstIndex(where: { (entity) -> Bool in
                let restaurantImages = entity as! RestaurantImages
                
                return restaurantImages.restaurantId == restaurantId
            }) {
                let object = entities[firstIndex] as! NSManagedObject
                
                restaurantsImages.remove(at: firstIndex)
                
                managedContext.delete(object)
                
                try managedContext.save()
            }
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func removeAll() {
        clearEntities(name: Entities.restaurantImages)
        restaurantsImages.removeAll()
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
        restaurantsImages.removeAll()
    }
}
