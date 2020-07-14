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
    
    private enum StoryboardIds {
        static let tableViewCell = "TableViewCell"
        static let editorViewController = "EditorViewController"
        static let customEditorViewController = "CustomEditorViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount: Int = 0
        
        if let unwrappedDataSource = dataSource {
            rowsCount = unwrappedDataSource.count()
        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIds.tableViewCell) as! TableViewCell
        
        if let unwrappedDataSource = dataSource {
            tableViewCell.setLabelText(text: String(unwrappedDataSource.get(at: indexPath.row)))
        }
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard!.instantiateViewController(withIdentifier: StoryboardIds.customEditorViewController) as! CustomEditorViewController
        editorViewController.selectMode(mode: CustomEditorViewControllerMode.edit)
        
        if let unwrappedDataSource = dataSource {
            editorViewController.number = unwrappedDataSource.get(at: indexPath.row)
            editorViewController.delegate = self
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
}

extension TableViewController: EditorViewControllerDelegate {
    func editorViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int) {
        if let unwrappedDataSource = dataSource {
            unwrappedDataSource.append(number: number)
        }
    }
    
    func editorViewControllerDelegateChangeSelectedNumber(_ viewController: UIViewController, newNumber: Int) {
        if let unwrappedDataSource = dataSource {
            let selectedRowIndex = tableView.indexPathForSelectedRow!.row
            unwrappedDataSource.replace(at: selectedRowIndex, with: newNumber)
        }
    }
    
    func editorViewControllerDelegateDeleteSelectedNumber(_ viewController: UIViewController) {
        if let unwrappedDataSource = dataSource {
            let selectedRowIndex = tableView.indexPathForSelectedRow!.row
            unwrappedDataSource.remove(at: selectedRowIndex)
        }
    }
}
