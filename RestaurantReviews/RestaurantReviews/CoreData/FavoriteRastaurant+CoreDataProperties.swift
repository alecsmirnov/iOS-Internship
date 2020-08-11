//
//  FavoriteRastaurant+CoreDataProperties.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoriteRastaurant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRastaurant> {
        return NSFetchRequest<FavoriteRastaurant>(entityName: "FavoriteRastaurant")
    }

    @NSManaged public var id: Int32

}
