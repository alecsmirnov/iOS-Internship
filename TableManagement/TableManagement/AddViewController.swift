//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol AddDelegate {
    func didAddNumber(number: Int)
}

class AddViewController: UIViewController {
    var addDelegate: AddDelegate!
    
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didPressAdd(_ sender: Any) {
        if !textField.text!.isEmpty {
            addDelegate?.didAddNumber(number: Int(textField.text!)!)
            
            textField.text = ""
        }
    }
}
