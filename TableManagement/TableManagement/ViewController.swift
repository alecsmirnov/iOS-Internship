//
//  ViewController.swift
//  TableManagement
//
//  Created by Admin on 30.06.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

let TableSize: Int = 50

class ViewController: UIViewController {
    var tableData: [Int] = DataSource.randomNumbers(size: TableSize);

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func setCurrentRow(number: Int) {
        tableData[tableView.indexPathForSelectedRow?.row ?? 0] = number
    }
    
    func getCurrentRow() -> Int {
        return tableView.indexPathForSelectedRow?.row ?? 0
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        
        cell.setLabelText(text: String(tableData[indexPath.row]))
        
        return cell;
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        detailViewController.setNumber(number: tableData[indexPath.row])
        detailViewController.editorDelegate = self
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension ViewController: EditorDelegate {
    func didNumberChange(newNumber: Int) {
        tableData[tableView.indexPathForSelectedRow?.row ?? 0] = newNumber
    }
}
