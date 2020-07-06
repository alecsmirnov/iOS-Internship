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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame: CGRect = view.frame
        
        let displayX: CGFloat = 0
        let displayY: CGFloat = 0
        let displayWidth: CGFloat = frame.width
        let displayHeight: CGFloat = frame.height
        
        let tableView = UITableView(frame: CGRect(x: displayX, y: displayY, width: displayWidth, height: displayHeight))
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
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
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard!.instantiateViewController(withIdentifier: "EditorViewController") as! EditorViewController
        
        if let unwrappedDataSource = dataSource {
            editorViewController.number = unwrappedDataSource.data[indexPath.row]
            editorViewController.delegate = self
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
    */
}
