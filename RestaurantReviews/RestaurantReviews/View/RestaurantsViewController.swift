//
//  RestaurantsViewController.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum StoryboardIds {
    static let tableViewCell            = "TableViewCell"
    static let restaurantViewController = "RestaurantViewController"
}

class RestaurantsViewController: UIViewController {
    var restaurantsViewModel: RestaurantsViewModel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let restaurantsViewModel = restaurantsViewModel {
            restaurantsViewModel.update()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = 0
        
        if let restaurantsViewModel = restaurantsViewModel {
            rowsCount = restaurantsViewModel.rowsCount
        }
        
        return rowsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIds.tableViewCell) as! TableViewCell
                
        if let restaurantsViewModel = restaurantsViewModel {
            tableViewCell.cellViewModel = restaurantsViewModel.cellViewModel(at: indexPath.row)
        }
        
        return tableViewCell;
    }
}

extension RestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let storyboard = storyboard {
            let restaurantViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIds.restaurantViewController) as! RestaurantViewController
            
            if let restaurantsViewModel = restaurantsViewModel {
                restaurantViewController.restaurantViewModel = restaurantsViewModel.restaurantViewModel(at: indexPath.row)
            }
            
            if let navigationController = navigationController {
                navigationController.pushViewController(restaurantViewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {       
        return restaurantsViewModel.displayMode == .all ? .none : .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let restaurantsViewModel = restaurantsViewModel {
            if editingStyle == .delete {
                restaurantsViewModel.userRemoveRestaurantFromFavorites(at: indexPath.row)
            }
        }
    }
}
