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
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var nameTextView: UITextView!
    @IBOutlet private var descriptionTextView: UITextView!
    @IBOutlet private var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let restaurantViewModel = restaurantViewModel {
            if let imagePath = restaurantViewModel.mainImagePath {
                mainImageView.getImage(url: imagePath)
            }
            
            nameTextView.text = restaurantViewModel.name
            descriptionTextView.text = restaurantViewModel.description
            ratingLabel.text = restaurantViewModel.rating
            
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
