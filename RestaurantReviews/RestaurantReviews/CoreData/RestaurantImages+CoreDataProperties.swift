//
//  RestaurantImages+CoreDataProperties.swift
//  RestaurantReviews
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension RestaurantImages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantImages> {
        return NSFetchRequest<RestaurantImages>(entityName: "RestaurantImages")
    }

    @NSManaged public var restaurantId: Int32
    @NSManaged public var images: NSSet

}

// MARK: Generated accessors for images
extension RestaurantImages {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
