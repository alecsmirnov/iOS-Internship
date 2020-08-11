//
//  RestaurantViewModelDelegate.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol RestaurantViewModelDelegate: AnyObject {
    func restaurantViewModelDelegate(_ viewModel: AnyObject, toFavorite id: Int)
}