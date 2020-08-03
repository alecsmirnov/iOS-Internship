//
//  ViewController.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum StoryboardIds {
    static let tableViewCell        = "TableViewCell"
    static let editorViewController = "EditorViewController"
}

private enum ScheduleReloadType: Equatable {
    case none
    case all
    case row(index: Int)
}

class TableViewController: UIViewController {
    var tableViewModel: TableViewModel!
    
    private var reloadType = ScheduleReloadType.none
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
        tableViewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch reloadType {
        case ScheduleReloadType.all:
            tableView.reloadData()
            break
        case ScheduleReloadType.row(let index):
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            break
        default:
            break
        }
        
        reloadType = ScheduleReloadType.none
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowsCount: Int = 0
        
        if let tableViewModel = tableViewModel {
            rowsCount = tableViewModel.count
        }
        
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: StoryboardIds.tableViewCell) as! TableViewCell
        
        if let tableViewModel = tableViewModel {
            tableViewCell.cellViewModel = tableViewModel.cellViewModel(at: indexPath.row)
        }
        
        return tableViewCell;
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let storyboard = storyboard {
            let editorViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIds.editorViewController) as! EditorViewController
            
            if let tableViewModel = tableViewModel {
                editorViewController.editorViewModel = tableViewModel.editorViewModel(at: indexPath.row)
            }
            
            if let navigationController = navigationController {
                navigationController.pushViewController(editorViewController, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableViewModel.userDeletedNumber(at: indexPath.row)
        }
    }
}

extension TableViewController: TableViewModelDisplayDelegate {
    func tableViewModelDisplayDelegateReloadRow(_ viewController: AnyObject, at index: Int) {
        if reloadType == ScheduleReloadType.none {
            reloadType = ScheduleReloadType.row(index: index)
        }
    }
    
    func tableViewModelDisplayDelegateReloadData(_ viewController: AnyObject) {
        reloadType = ScheduleReloadType.all
    }
}
