//
//  TableViewController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    let tableView = UITableView()
    var dataSource: DataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.frame
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        view.addSubview(tableView)
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount: Int = 0
        
        if let unwrappedDataSource = dataSource {
            rowsCount = unwrappedDataSource.data.count
        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        if let unwrappedDataSource = dataSource {
            tableViewCell.setLabelText(text: String(unwrappedDataSource.data[indexPath.row]))
        }
        
        return tableViewCell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = EditorViewController()
        
        if let unwrappedDataSource = dataSource {
            editorViewController.number = unwrappedDataSource.data[indexPath.row]
            editorViewController.delegate = self
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
}

extension TableViewController: TableViewControllerDelegate {
    func tableViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int) {
        if let unwrappedDataSource = dataSource {
            unwrappedDataSource.data.append(number)
        }
    }
    
    func tableViewControllerDelegateChangeSelectedNumber(_ viewController: UIViewController, newNumber: Int) {
        if let unwrappedDataSource = dataSource {
            unwrappedDataSource.data[tableView.indexPathForSelectedRow!.row] = newNumber
        }
    }
    
    func tableViewControllerDelegateDeleteSelectedNumber(_ viewController: UIViewController) {
        if let unwrappedDataSource = dataSource {
            unwrappedDataSource.data.remove(at: tableView.indexPathForSelectedRow!.row)
        }
    }
}
