//
//  Restaurant+CoreDataProperties.swift
//  RestaurantReviews
//
//  Created by Admin on 18.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData

extension Restaurant {
    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var descriptionText: String
    @NSManaged public var address: String
    @NSManaged public var rating: Float
    @NSManaged public var location: Location
    
    @NSManaged public var images: NSSet
    @NSManaged public var reviews: NSSet
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }
}

// MARK: Generated accessors for images
extension Restaurant {
    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)
}

// MARK: Generated accessors for reviews
extension Restaurant {
    @objc(addReviewsObject:)
    @NSManaged public func addToReviews(_ value: Review)

    @objc(removeReviewsObject:)
    @NSManaged public func removeFromReviews(_ value: Review)

    @objc(addReviews:)
    @NSManaged public func addToReviews(_ values: NSSet)

    @objc(removeReviews:)
    @NSManaged public func removeFromReviews(_ values: NSSet)
}
