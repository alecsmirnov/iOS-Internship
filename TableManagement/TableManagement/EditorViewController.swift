//
//  DetailViewController.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol EditorDelegate {
    func didChangeNumber(newNumber: Int)
    func didDeleteNumber()
}

class EditorViewController: UIViewController {  
    var number: Int!
    var editorDelegate: EditorDelegate!
    
    @IBOutlet var numberField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        numberField.text = String(number)
    }
    
    @IBAction func didPressEdit(_ sender: UIButton) {
        editorDelegate?.didChangeNumber(newNumber: Int(numberField.text!)!)
    }
    
    @IBAction func didPressDelete(_ sender: UIButton) {
        editorDelegate?.didDeleteNumber()
        
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
