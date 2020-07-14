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
    private var mode = CustomEditorViewControllerMode.add
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch mode {
        case CustomEditorViewControllerMode.edit:
            showEdit()
            break
        case CustomEditorViewControllerMode.add:
            showAdd()
            break
        }
    }
    
    func selectMode(mode: CustomEditorViewControllerMode) {
        self.mode = mode
    }
    
    private func showEdit() {
        addButton.isHidden = true
    }
    
    private func showAdd() {
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
}
