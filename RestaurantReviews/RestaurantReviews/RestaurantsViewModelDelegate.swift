//
//  RestaurantsViewModelDelegate.swift
//  RestaurantReviews
//
//  Created by Admin on 17.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol RestaurantsViewModelDelegate: AnyObject {
    func restaurantsViewModelDelegateReloadData(_ viewController: AnyObject)
}
