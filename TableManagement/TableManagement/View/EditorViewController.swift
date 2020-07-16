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
        
        applyEditorMode()
    }
    
    private func applyEditorMode() {
        if let editorViewModel = editorViewModel {
            if let editorMode = editorViewModel.mode {
                switch editorMode {
                case EditorMode.edit:
                    showEditMode()
                    break
                case EditorMode.add:
                    showAddMode()
                    break
                }
            }
        }
        else {
            showAddMode()
        }
    }
    
    private func showEditMode() {
        addButton.isHidden = true
        numberField.text = editorViewModel.text
    }
    
    private func showAddMode() {
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.userAddedNewNumber(text: numberField.text)
            
            numberField.text = ""
        }
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.userChangedSelectedNumber(text: numberField.text)
        }
    }
    
    @IBAction func didTapDelete(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.userdDeletedSelectedNumber()
            
            navigationController!.popViewController(animated: true);
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
