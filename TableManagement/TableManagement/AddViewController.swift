//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    private weak var delegate: TableViewControllerDelegate?
    
    @IBOutlet private var numberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setDelegate(delegate: TableViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @IBAction private func didPressAdd(_ sender: Any) {
        if !numberField.text!.isEmpty {
            delegate!.tableViewControllerDelegateAddNumber(self, number: Int(numberField.text!)!)
            
            numberField.text = ""
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
