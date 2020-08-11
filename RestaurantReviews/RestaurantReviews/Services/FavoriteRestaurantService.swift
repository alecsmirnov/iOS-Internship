//
//  FavoriteRestaurantService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

private enum Entities {
    static let favoriteRestaurant = "FavoriteRestaurant"
}

class FavoriteRestaurantService {
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    var count: Int {
        return favorites.count
    }
    
    private var favorites: [FavoriteRastaurant] = []
    
    func save(id: Int) {
        DispatchQueue.main.async { [unowned self] in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let favoriteRestaurantEntity = NSEntityDescription.entity(forEntityName: Entities.favoriteRestaurant, in: managedContext)!
            let favoriteRestaurant = FavoriteRastaurant(entity: favoriteRestaurantEntity, insertInto: managedContext)
            
            favoriteRestaurant.id = Int32(id)
            
            do {
                try managedContext.save()

                self.favorites.append(favoriteRestaurant)
            } catch let error as NSError {
                fatalError("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func load() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<FavoriteRastaurant> = FavoriteRastaurant.fetchRequest()

        do {
            self.favorites = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func remove(id: Int) {
        if let index = favorites.firstIndex(where: { (favoriteRestaurant) -> Bool in
            favoriteRestaurant.id == id
        }) {
            favorites.remove(at: index)
            
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }

                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.favoriteRestaurant)

                do {
                    let entities = try managedContext.fetch(fetchRequest) as! [FavoriteRastaurant]

                    if let index = entities.firstIndex(where: { (favoriteRestaurant) -> Bool in
                        favoriteRestaurant.id == id
                    }) {
                        let object = entities[index] as NSManagedObject
                        
                        managedContext.delete(object)
                    }
                } catch let error as NSError {
                    fatalError("Could not fetch. \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func get(at index: Int) -> Int {
        return Int(favorites[index].id)
    }
    
    func contains(id: Int) -> Bool {
        return favorites.contains { (favoriteRestaurant) -> Bool in
            favoriteRestaurant.id == id
        }
    }
    
    func clear() {
        clearEntities()
        favorites.removeAll()
    }
    
    private func clearEntities() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.favoriteRestaurant)

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
