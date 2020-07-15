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
    static let customEditorViewController = "CustomEditorViewController"
}

class TableViewController: UIViewController {
    var numbersDataViewModel: NumbersDataViewModel!
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
        
        if let numbersDataViewModel = numbersDataViewModel {
            rowsCount = numbersDataViewModel.count()
        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIds.tableViewCell) as! TableViewCell
        
        if let numbersDataViewModel = numbersDataViewModel {
            tableViewCell.cellViewModel = CellViewModel(number: numbersDataViewModel.get(at: indexPath.row))
        }
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard!.instantiateViewController(withIdentifier: StoryboardIds.customEditorViewController) as! CustomEditorViewController
        
        if let numbersDataViewModel = numbersDataViewModel, let editorViewModel = editorViewModel {
            editorViewModel.setMode(mode: CustomEditorViewControllerMode.edit)
            editorViewModel.setNumber(number: numbersDataViewModel.get(at: indexPath.row))
            editorViewController.editorViewModel = editorViewModel
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
}

extension TableViewController: EditorViewControllerDelegate {
    func editorViewControllerDelegateAddNumber(_ viewController: AnyObject, number: Int) {
        if let numbersDataViewModel = numbersDataViewModel {
            numbersDataViewModel.append(number: number)
        }
    }
    
    func editorViewControllerDelegateChangeSelectedNumber(_ viewController: AnyObject, newNumber: Int) {
        if let numbersDataViewModel = numbersDataViewModel {
            let selectedRowIndex = tableView.indexPathForSelectedRow!.row
            numbersDataViewModel.replace(at: selectedRowIndex, with: newNumber)
        }
    }
    
    func editorViewControllerDelegateDeleteSelectedNumber(_ viewController: AnyObject) {
        if let numbersDataViewModel = numbersDataViewModel {
            let selectedRowIndex = tableView.indexPathForSelectedRow!.row
            numbersDataViewModel.remove(at: selectedRowIndex)
        }
    }
}
