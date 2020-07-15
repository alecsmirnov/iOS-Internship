//
//  ViewController.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum StoryboardIds {
    static let tableViewCell = "TableViewCell"
    static let editorViewController = "EditorViewController"
}

class TableViewController: UIViewController {
    var tableViewModel: TableViewModel!
    var editorViewModel: EditorViewModel!
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let tableView = self.tableView {
            tableView.reloadData()
        }
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount: Int = 0
        
        if let tableViewModel = tableViewModel {
            rowsCount = tableViewModel.count()
        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIds.tableViewCell) as! TableViewCell
        
        if let tableViewModel = tableViewModel {
            tableViewCell.cellViewModel = CellViewModel(number: tableViewModel.get(at: indexPath.row))
        }
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard!.instantiateViewController(withIdentifier: StoryboardIds.editorViewController) as! EditorViewController
        
        if let editorViewModel = editorViewModel {
            editorViewModel.setSelectedIndex(indexPath.row)
            editorViewController.editorViewModel = editorViewModel
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
}
