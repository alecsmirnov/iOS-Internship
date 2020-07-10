//
//  TableViewController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    var dataSource: DataSource?
    
    private var tableView: UITableView!
    
    override func loadView() {
        setupView()
        
        setupTableView()
        
        setupTableViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    private func setupView() {
        view = UIView()
        
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .white
    }
    
    private func setupTableView() {
        tableView = UITableView()
        
        tableView.frame = view.frame
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        view.addSubview(tableView)
    }
    
    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = NSLayoutConstraint(item: tableView!, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: tableView!, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: tableView!, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: tableView!, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        
        let constraints = [topConstraint, bottomConstraint, leftConstraint, rightConstraint]
        
        view.addConstraints(constraints)
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
