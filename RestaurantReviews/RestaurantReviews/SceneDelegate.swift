//
//  SceneDelegate.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private var restaurantsModel: RestaurantsModel!
    private var favoriteRestaurantIds: FavoriteRestaurantIds!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
                
        guard let window = window else {
            fatalError("Cannot attach window to the scene")
        }
        
        restaurantsModel = RestaurantsModel()
        favoriteRestaurantIds = FavoriteRestaurantIds()
        
        restaurantsModel.load()
        favoriteRestaurantIds.load()
        
        restaurantsModel.setUpdateTime(second: 5, minute: 0, hour: 0, day: 0)
        
        let tabBarController = window.rootViewController as! UITabBarController
        let restaurantsNavigationController = tabBarController.viewControllers![0] as! UINavigationController
        let favoritesNavigationController = tabBarController.viewControllers![2] as! UINavigationController
        
        tabBarController.tabBar.items![2].title = "Favorites"
        tabBarController.tabBar.items![2].image = UIImage(systemName: "star")
        tabBarController.tabBar.items![2].selectedImage = UIImage(systemName: "star.fill")
        
        let restaurantsViewController = restaurantsNavigationController.viewControllers[0] as! RestaurantsViewController
        //let mapViewController = tabBarController.viewControllers![1] as! MapViewController
        //let favoritesViewController = tabBarController.viewControllers![2] as! RestaurantsViewController
        let favoritesViewController = favoritesNavigationController.viewControllers[0] as! RestaurantsViewController
        
        let restaurantsViewModel = RestaurantsViewModel(restaurantsModel: restaurantsModel, favoriteRestaurantIds: favoriteRestaurantIds, displayMode: .all)
        let favoritesViewModel = RestaurantsViewModel(restaurantsModel: restaurantsModel, favoriteRestaurantIds: favoriteRestaurantIds, displayMode: .favorites)
        
        restaurantsModel.delegate = restaurantsViewModel
        
        restaurantsViewController.restaurantsViewModel = restaurantsViewModel
        favoritesViewController.restaurantsViewModel = favoritesViewModel
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
