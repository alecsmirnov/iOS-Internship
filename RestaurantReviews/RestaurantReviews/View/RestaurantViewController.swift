//
//  RestaurantViewController.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum ImageSystemNames {
    static let star     = "star"
    static let starFill = "star.fill"
}

private enum NotificationNames {
    static let onReceiveMessage = NSNotification.Name("onReceiveMessage")
}

class RestaurantViewController: UIViewController {
    var restaurantViewModel: RestaurantViewModel!
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var nameTextView: UITextView!
    @IBOutlet private var descriptionTextView: UITextView!
    @IBOutlet private var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let restaurantViewModel = restaurantViewModel {
            restaurantViewModel.addObserver(self, selector: #selector(onReceiveMessage(_:)), name: NotificationNames.onReceiveMessage)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let restaurantViewModel = restaurantViewModel {
            if let imagePath = restaurantViewModel.mainImagePath {
                mainImageView.loadImage(url: imagePath)
            }
            
            nameTextView.text = restaurantViewModel.name
            descriptionTextView.text = restaurantViewModel.description
            ratingLabel.text = restaurantViewModel.rating
            
           showFavoriteStatusImage()
        }
    }
    
    @IBAction private func didTapFavorite(_ sender: UIBarButtonItem) {
        if let restaurantViewModel = restaurantViewModel {
            restaurantViewModel.userChangeFavoriteStatus()
            
            showFavoriteStatusImage()
            onSendMessage()
        }
    }
    
    private func showFavoriteStatusImage() {
        if let restaurantViewModel = restaurantViewModel {
            if restaurantViewModel.favorite {
                changeFavoriteImage(systemName: ImageSystemNames.starFill)
            }
            else {
                changeFavoriteImage(systemName: ImageSystemNames.star)
            }
        }
    }
    
    private func changeFavoriteImage(systemName: String) {
        if let buttonItem = navigationItem.rightBarButtonItem {
            buttonItem.image = UIImage(systemName: systemName)
        }
    }
    
    private func onSendMessage() {
        if let restaurantViewModel = restaurantViewModel {
            restaurantViewModel.removeObserver(self)
            restaurantViewModel.post(name: NotificationNames.onReceiveMessage)
            restaurantViewModel.addObserver(self, selector: #selector(onReceiveMessage(_:)), name: NotificationNames.onReceiveMessage)
        }
    }
    
    @objc private func onReceiveMessage(_ notification: Notification) {
        if let restaurantViewModel = restaurantViewModel {
            restaurantViewModel.switchFavoriteStatus()
            
            showFavoriteStatusImage()
        }
    }
}
