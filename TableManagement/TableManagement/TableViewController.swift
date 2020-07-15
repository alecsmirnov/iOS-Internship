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
    weak var numbersDataViewModel: NumbersDataViewModel! {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
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
            tableViewCell.cellViewModel = numbersDataViewModel.cellViewModel(at: indexPath.row)
        }
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editorViewController = storyboard!.instantiateViewController(withIdentifier: StoryboardIds.customEditorViewController) as! CustomEditorViewController
        //editorViewController.selectMode(mode: CustomEditorViewControllerMode.edit)
        
        if let numbersDataViewModel = numbersDataViewModel {
            //editorViewController.number = numbersDataViewModel.get(at: indexPath.row)
            //editorViewController.delegate = self
            
            editorViewController.editorViewModel = numbersDataViewModel.editorViewModel
        }

        navigationController!.pushViewController(editorViewController, animated: true)
    }
}

extension TableViewController: EditorViewControllerDelegate {
    func editorViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int) {
        if let numbersDataViewModel = numbersDataViewModel {
            numbersDataViewModel.append(number: number)
        }
    }
    
    func editorViewControllerDelegateChangeSelectedNumber(_ viewController: UIViewController, newNumber: Int) {
        if let numbersDataViewModel = numbersDataViewModel {
            let selectedRowIndex = tableView.indexPathForSelectedRow!.row
            numbersDataViewModel.replace(at: selectedRowIndex, with: newNumber)
        }
    }
    
    func editorViewControllerDelegateDeleteSelectedNumber(_ viewController: UIViewController) {
        if let numbersDataViewModel = numbersDataViewModel {
            let selectedRowIndex = tableView.indexPathForSelectedRow!.row
            numbersDataViewModel.remove(at: selectedRowIndex)
        }
    }
}
