//
//  ViewController.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

let TableSize: Int = 50

enum TabBarItems {
    static let table: Int = 0
    static let add: Int = 1
    static let statistics: Int = 2
}

class TableViewController: UIViewController {
    private var tableData: [Int] = []
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self

        tabBarController?.delegate = self
        
        tableData = DataSource.randomNumbers(size: TableSize)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        tableViewCell.setLabelText(text: String(tableData[indexPath.row]))
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard?.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        
        editorViewController.setDelegate(delegate: self)
        
        navigationController?.pushViewController(editorViewController, animated: true)
    }
}

extension TableViewController: UITabBarControllerDelegate {   
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = self.tabBarController!.selectedIndex
        
        switch tabBarIndex {
        case TabBarItems.add:
            let addViewController = viewController as! AddViewController
            addViewController.setDelegate(delegate: self)
            break
        case TabBarItems.statistics:
            let statisticsViewController = viewController as! StatisticsViewController
            statisticsViewController.setDelegate(delegate: self)
            break
        default:
            break
        }
    }
}

extension TableViewController: TableViewControllerDelegate {
    func tableViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int) {
        tableData.append(number)
    }
    
    func tableViewControllerDelegateChangeSelectedNumber(_ viewController: UIViewController, newNumber: Int) {
        tableData[tableView.indexPathForSelectedRow!.row] = newNumber
    }
    
    func tableViewControllerDelegateDeleteSelectedNumber(_ viewController: UIViewController) {
        tableData.remove(at: tableView.indexPathForSelectedRow!.row)
    }
    
    func tableViewControllerDelegateGetSelectedNumber(_ viewController: UIViewController) -> Int {
        return tableData[tableView.indexPathForSelectedRow!.row]
    }
    
    func tableViewControllerDelegateGetNumbers(_ viewController: UIViewController) -> [Int] {
        return tableData
    }
}
