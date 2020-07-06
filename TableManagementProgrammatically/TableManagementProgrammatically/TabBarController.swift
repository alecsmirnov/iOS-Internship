//
//  TabBarController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dataSource: DataSource = DataSource(size: TableSize)
        
        let tableViewController = TableViewController()
        tableViewController.dataSource = dataSource
        
        let navigationController = UINavigationController(rootViewController: tableViewController)
        let addViewController = AddViewController()
        let statisticsViewController = StatisticsViewController()
        
        navigationController.tabBarItem = UITabBarItem(title: "Table", image: UIImage(systemName: "table"), tag: TabBarItems.table)
        addViewController.tabBarItem = UITabBarItem(title: "Add", image: UIImage(systemName: "plus"), tag: TabBarItems.add)
        statisticsViewController.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar"), tag: TabBarItems.statistics)
        
        let controllers: [UIViewController] = [navigationController, addViewController, statisticsViewController]
        self.viewControllers = controllers
    }
}
