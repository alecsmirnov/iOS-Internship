//
//  DetailViewController.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol EditorDelegate {
    func didNumberChange(newNumber: Int)
}

class DetailViewController: UIViewController {
    var number: Int?
    var editorDelegate: EditorDelegate?
    
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textField.text = String(number ?? 0)
    }
    
    func setNumber(number: Int) {
        self.number = number
    }
    
    @IBAction func didPressButton(_ sender: UIButton) {
        editorDelegate?.didNumberChange(newNumber: Int(textField.text ?? "") ?? 0)
    }
}
