//
//  FavoriteRestaurantIds.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class FavoriteRestaurantIds {
    var isEmpty: Bool {
        return favorites.isEmpty
    }
    
    var count: Int {
        return favorites.count
    }
    
    private var favorites: FavoriteRestaurantService
    
    init() {
        favorites = FavoriteRestaurantService()
    }
    
    func append(id: Int) {
        if !favorites.contains(id: id) {
            favorites.append(id)
        }
    }
    
    func remove(id: Int) {
        favorites.remove(id: id)
    }
    
    func isFavorite(id: Int) -> Bool {
        return favorites.contains(id: id)
    }
    
    func get(at index: Int) -> Int {
        return favorites.get(at: index)
    }
    
    func load() {
        favorites.load()
    }
    
    func removeAll() {
        favorites.removeAll()
    }
}
