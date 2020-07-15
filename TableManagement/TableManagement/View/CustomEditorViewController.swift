//
//  EditorViewControllerMode.swift
//  TableManagement
//
//  Created by Admin on 14.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

enum CustomEditorViewControllerMode {
    case edit
    case add
}

class CustomEditorViewController: EditorViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch editorViewModel.mode() {
        case CustomEditorViewControllerMode.edit:
            showEdit()
            break
        case CustomEditorViewControllerMode.add:
            showAdd()
            break
        }
    }
    
    private func showEdit() {
        addButton.isHidden = true
    }
    
    private func showAdd() {
        numberField.text = ""
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
}
