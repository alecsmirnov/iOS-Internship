//
//  RestaurantReviews+CoreDataProperties.swift
//  RestaurantReviews
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension RestaurantReviews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantReviews> {
        return NSFetchRequest<RestaurantReviews>(entityName: "RestaurantReviews")
    }

    @NSManaged public var restaurantId: Int32
    @NSManaged public var reviews: NSSet

}

// MARK: Generated accessors for reviews
extension RestaurantReviews {

    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)

}
