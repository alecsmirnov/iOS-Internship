//
//  RestaurantsModelDisplayDelegate.swift
//  RestaurantReviews
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol RestaurantsModelDisplayDelegate: AnyObject {
    func restaurantsModelDisplayDelegateReloadRow(_ viewController: AnyObject, at index: Int)
    func restaurantsModelDisplayDelegateReloadData(_ viewController: AnyObject)
}
