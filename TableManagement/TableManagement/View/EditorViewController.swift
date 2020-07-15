//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    var editorViewModel: EditorViewModel!

    @IBOutlet var numberField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyMode()
    }
    
    private func applyMode() {
        if let editorViewModel = editorViewModel {
            switch editorViewModel.mode() {
            case EditorMode.edit:
                showEdit()
                numberField.text = editorViewModel.textNumber()
                break
            case EditorMode.add:
                showAdd()
                break
            }
        }
        else {
            showAdd()
        }
    }
    
    private func showEdit() {
        addButton.isHidden = true
    }
    
    private func showAdd() {       
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @IBAction private func didPressAdd(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if let numberString = numberField.text {
                editorViewModel.addNumber(numberString: numberString)
                
                numberField.text = ""
            }
        }
    }
    
    @IBAction func didPressEdit(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if let newNumberString = numberField.text {
                editorViewModel.changeSelectedNumber(newNumberString: newNumberString)
            }
        }
    }
    
    @IBAction func didPressDelete(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.deleteSelectedNumber()
            
            navigationController!.popViewController(animated: true);
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
