//
//  Review+CoreDataProperties.swift
//  RestaurantReviews
//
//  Created by Admin on 18.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData

extension Review {
    @NSManaged public var restaurantId: Int32
    @NSManaged public var author: String
    @NSManaged public var date: String
    @NSManaged public var reviewText: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Review> {
        return NSFetchRequest<Review>(entityName: "Review")
    }
}
