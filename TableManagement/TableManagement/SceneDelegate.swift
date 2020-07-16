//
//  SceneDelegate.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private let DataSize: Int = 50

private enum TabBarItems {
    static let table: Int = 0
    static let add: Int = 1
    static let statistics: Int = 2
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var numbersData: NumbersData!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let window = window else {
            fatalError("Cannot attach window to the scene")
        }
        
        let tabBarController = window.rootViewController as! UITabBarController
        let navigationController = tabBarController.viewControllers![TabBarItems.table] as! UINavigationController
        
        let tableViewController = navigationController.viewControllers[TabBarItems.table] as! TableViewController
        let addViewController = tabBarController.viewControllers![TabBarItems.add] as! EditorViewController
        let statisticsViewController = tabBarController.viewControllers![TabBarItems.statistics] as! StatisticsViewController
        
        numbersData = NumbersData(size: DataSize)
        
        let tableViewModel = TableViewModel(numbersData: numbersData)
        let addViewModel = EditorViewModel(mode: EditorMode.add, number: nil, delegate: tableViewModel)
        let statisticsViewModel = StatisticsViewModel(numbersData: numbersData)
        
        addViewController.editorViewModel = addViewModel
        tableViewController.tableViewModel = tableViewModel
        statisticsViewController.statisticsViewModel = statisticsViewModel
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
    }
}
