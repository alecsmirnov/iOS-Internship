//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    var number: Int?
    weak var delegate: EditorViewControllerDelegate?
    
    @IBOutlet private var numberField: UITextField!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let unwrappedNumber = number {
            numberField.text = String(unwrappedNumber)
        }
    }
    
    @IBAction private func didPressAdd(_ sender: Any) {
        if let unwrappedDelegate = delegate {
            if !numberField.text!.isEmpty {
                unwrappedDelegate.editorViewControllerDelegateAddNumber(self, number: Int(numberField.text!)!)
                
                numberField.text = ""
            }
        }
    }
    
    @IBAction func didPressEdit(_ sender: Any) {
        if let unwrappedDelegate = delegate {
            unwrappedDelegate.editorViewControllerDelegateChangeSelectedNumber(self, newNumber: Int(numberField.text!)!)
        }
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        if let unwrappedDelegate = delegate {
            unwrappedDelegate.editorViewControllerDelegateDeleteSelectedNumber(self)
            
            navigationController!.popViewController(animated: true);
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
