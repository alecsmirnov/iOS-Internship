//
//  Coordinates+CoreDataProperties.swift
//  RestaurantReviews
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//
//

import Foundation
import CoreData


extension Coordinates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coordinates> {
        return NSFetchRequest<Coordinates>(entityName: "Coordinates")
    }

    @NSManaged public var lat: Float
    @NSManaged public var lon: Float

}
