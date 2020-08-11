//
//  RestaurantViewController.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RestaurantViewController: UIViewController {
    var restaurantViewModel: RestaurantViewModel!

    @IBOutlet var favoriteStatusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantViewModel = restaurantViewModel {
            favoriteStatusLabel.text = String(restaurantViewModel.favorite)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: UIButton) {
        if let restaurantViewModel = restaurantViewModel {
            restaurantViewModel.userChangeFavoriteStatus()
            
            favoriteStatusLabel.text = String(restaurantViewModel.favorite)
        }
    }
}
