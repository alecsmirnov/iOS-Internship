//
//  DetailViewController.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    var number: Int?
    weak var delegate: TableViewControllerDelegate?
    
    @IBOutlet private var numberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        if let unwrappedNumber = number {
            numberField.text = String(unwrappedNumber)
        }
    }
    
    @IBAction private func didPressEdit(_ sender: UIButton) {
        if let unwrappedDelegate = delegate {
            unwrappedDelegate.tableViewControllerDelegateChangeSelectedNumber(self, newNumber: Int(numberField.text!)!)
        }
    }
    
    @IBAction private func didPressDelete(_ sender: UIButton) {
        if let unwrappedDelegate = delegate {
            unwrappedDelegate.tableViewControllerDelegateDeleteSelectedNumber(self)
            
            navigationController!.popViewController(animated: true);
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
