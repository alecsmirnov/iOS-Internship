//
//  FavoriteRestaurantService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

class FavoriteRestaurantService {
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    var count: Int {
        return favorites.count
    }
    
    private var favorites: [Favorite] = []
    private var managedContext: NSManagedObjectContext?
    
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func append(_ id: Int) {
        DispatchQueue.main.async { [unowned self] in
            if let managedContext = self.managedContext {
                guard let favoriteRestaurantEntity = NSEntityDescription.entity(forEntityName: Entities.favorite, in: managedContext) else {
                    fatalError("Incorrect entity name: \(Entities.favorite)")
                }
                
                let favoriteRestaurant = Favorite(entity: favoriteRestaurantEntity, insertInto: managedContext)
                
                favoriteRestaurant.restaurantId = Int32(id)
                
                do {
                    try managedContext.save()

                    self.favorites.append(favoriteRestaurant)
                } catch let error as NSError {
                    fatalError("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func load() {
        if let managedContext = self.managedContext {
            let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()

            do {
                self.favorites = try managedContext.fetch(fetchRequest)
            } catch let error as NSError {
                fatalError("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    
    func remove(id: Int) {
        if let index = favorites.firstIndex(where: { (favoriteRestaurant) -> Bool in
            favoriteRestaurant.restaurantId == id
        }) {
            favorites.remove(at: index)
            
            DispatchQueue.main.async {
                if let managedContext = self.managedContext {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.favorite)

                    do {
                        let entities = try managedContext.fetch(fetchRequest) as! [Favorite]

                        if let index = entities.firstIndex(where: { (favoriteRestaurant) -> Bool in
                            favoriteRestaurant.restaurantId == id
                        }) {
                            let object = entities[index] as NSManagedObject
                            
                            managedContext.delete(object)
                            
                            try managedContext.save()
                        }
                    } catch let error as NSError {
                        fatalError("Could not fetch. \(error), \(error.userInfo)")
                    }
                }
            }
        }
    }
    
    func get(at index: Int) -> Int {
        return Int(favorites[index].restaurantId)
    }
    
    func contains(id: Int) -> Bool {
        return favorites.contains { (favoriteRestaurant) -> Bool in
            favoriteRestaurant.restaurantId == id
        }
    }
    
    func removeAll() {
        clearEntities()
        favorites.removeAll()
    }
    
    private func clearEntities() {
        DispatchQueue.main.async {
            if let managedContext = self.managedContext {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.favorite)

                do {
                    let entities = try managedContext.fetch(fetchRequest)

                    for entity in entities {
                        let object = entity as! NSManagedObject

                        managedContext.delete(object)
                    }
                } catch let error as NSError {
                    fatalError("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    deinit {
        favorites.removeAll()
    }
}
