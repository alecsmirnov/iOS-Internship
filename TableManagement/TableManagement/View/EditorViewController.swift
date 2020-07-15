//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    weak var editorViewModel: EditorViewModel!

    @IBOutlet var numberField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let editorViewModel = editorViewModel {
            numberField.text = editorViewModel.text()
        }
    }
    
    @IBAction private func didPressAdd(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if !numberField.text!.isEmpty {
                editorViewModel.addNumber(self, number: Int(numberField.text!)!)
                
                numberField.text = ""
            }
        }
    }
    
    @IBAction func didPressEdit(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.changeNumber(self, newNumber: Int(numberField.text!)!)
        }
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.deleteNumber(self)
            
            navigationController!.popViewController(animated: true);
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
