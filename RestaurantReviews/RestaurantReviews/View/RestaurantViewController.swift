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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let restaurantViewModel = restaurantViewModel {
            changeFavoriteStatus(restaurantViewModel.favorite)
        }
    }
    
    @IBAction func didTapFavorite(_ sender: UIBarButtonItem) {
        if let restaurantViewModel = restaurantViewModel {
            restaurantViewModel.userChangeFavoriteStatus()
            
            changeFavoriteStatus(restaurantViewModel.favorite)
        }
    }
    
    private func changeFavoriteStatus(_ status: Bool) {
        if status {
            changeFavoriteItemImage(systemName: "star.fill")
        }
        else {
            changeFavoriteItemImage(systemName: "star")
        }
    }
    
    private func changeFavoriteItemImage(systemName: String) {
        if let buttonItem = navigationItem.rightBarButtonItem {
            buttonItem.image = UIImage(systemName: systemName)
        }
    }
}
