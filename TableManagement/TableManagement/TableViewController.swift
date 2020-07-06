//
//  ViewController.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    var dataSource: DataSource?
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self

        tabBarController!.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        if let unwrappedDataSource = dataSource {
            tableViewCell.setLabelText(text: String(unwrappedDataSource.data[indexPath.row]))
        }
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard!.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        
        if let unwrappedDataSource = dataSource {
            editorViewController.number = unwrappedDataSource.data[indexPath.row]
            editorViewController.delegate = self
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
}

extension TableViewController: UITabBarControllerDelegate {}

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
