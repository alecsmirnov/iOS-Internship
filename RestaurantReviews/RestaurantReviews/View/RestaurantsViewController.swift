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
    
    @IBOutlet private var empyTableLabel: UILabel!
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let restaurantsViewModel = restaurantsViewModel {
            restaurantsViewModel.update() { [unowned self] in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension RestaurantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount = 0
        
        if let restaurantsViewModel = restaurantsViewModel {
            if restaurantsViewModel.isEmpty {
                if restaurantsViewModel.self is FavoriteRestaurantsViewModel {
                    empyTableLabel.text = "You do not have any favorite restaurants"
                    empyTableLabel.isHidden = false
                    
                    searchBar.isHidden = true
                }
                else {
                    empyTableLabel.text = "No restaurant data"
                }
                
                tableView.separatorStyle = .none
            }
            else {
                empyTableLabel.isHidden = true
                
                searchBar.isHidden = false
                tableView.separatorStyle = .singleLine
                
                rowsCount = restaurantsViewModel.rowsCount
            }
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
        return restaurantsViewModel.self is FavoriteRestaurantsViewModel ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let restaurantsViewModel = restaurantsViewModel {
            if editingStyle == .delete {
                restaurantsViewModel.userRemoveRestaurantFromFavorites(at: indexPath.row)
                
                tableView.reloadData()
            }
        }
    }
}

extension RestaurantsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let restaurantsViewModel = restaurantsViewModel {
            if !searchText.isEmpty {
                restaurantsViewModel.setFilter(text: searchText)
            }
            else {
                restaurantsViewModel.clearFilter()
            }
            
            tableView.reloadData()
        }
    }
}
