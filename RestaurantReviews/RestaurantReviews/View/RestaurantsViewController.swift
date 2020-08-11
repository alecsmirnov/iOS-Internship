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
    static let restaurantViewController = "restaurantViewController"
}

class RestaurantsViewController: UIViewController {
    var restaurantsViewModel: RestaurantsViewModel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        if let restaurantsViewModel = restaurantsViewModel {
            restaurantsViewModel.update()
        }
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
