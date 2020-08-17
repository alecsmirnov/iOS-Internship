//
//  FavoritesService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import CoreData

class FavoritesService {
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    var count: Int {
        return favorites.count
    }
    
    private var favorites: [Favorite] = []
    
    func append(id: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let favoriteEntity = NSEntityDescription.entity(forEntityName: Entities.favorite, in: managedContext) else {
            fatalError("Incorrect entity name: \(Entities.favorite)")
        }
        
        let favorite = Favorite(entity: favoriteEntity, insertInto: managedContext)
        
        favorite.restaurantId = Int32(id)
        
        do {
            try managedContext.save()

            favorites.append(favorite)
        } catch let error as NSError {
            fatalError("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func load() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()

        do {
            favorites = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            fatalError("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func remove(id: Int) {
        if let index = favorites.firstIndex(where: { (favorite) -> Bool in
            favorite.restaurantId == id
        }) {
            favorites.remove(at: index)
            
            DispatchQueue.main.async {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }

                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entities.favorite)

                do {
                    let entities = try managedContext.fetch(fetchRequest) as! [Favorite]

                    if let index = entities.firstIndex(where: { (favorite) -> Bool in
                        favorite.restaurantId == id
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
    
    func get(at index: Int) -> Int {
        return Int(favorites[index].restaurantId)
    }
    
    func contains(id: Int) -> Bool {
        return favorites.contains { (favorite) -> Bool in
            favorite.restaurantId == id
        }
    }
    
    func removeAll() {
        clearEntities()
        favorites.removeAll()
    }
    
    private func clearEntities() {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
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
    
    deinit {
        favorites.removeAll()
    }
}
