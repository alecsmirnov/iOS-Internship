//
//  ViewController.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

let TableSize: Int = 50

enum TabBarViewControllers {
    static let table: Int = 0
    static let statistics: Int = 1
}

class TableViewController: UIViewController {
    var tableData: [Int] = []

    @IBOutlet var tableView: UITableView!
    
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
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailViewController.setNumber(number: tableData[indexPath.row])
        detailViewController.editorDelegate = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension TableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let statisticsViewController = (self.tabBarController?.viewControllers![TabBarViewControllers.statistics]) as! StatisticsViewController
        statisticsViewController.tableData = tableData
        
        return true
    }
}

extension TableViewController: EditorDelegate {
    func didNumberChange(newNumber: Int) {
        tableData[tableView.indexPathForSelectedRow?.row ?? 0] = newNumber
    }
    
    func didNumberDelet() {
        tableData.remove(at: tableView.indexPathForSelectedRow?.row ?? 0)
    }
}
