//
//  EditorViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum EditorMode {
    case edit
    case add
}

class EditorViewModel {
    var mode: EditorMode!
    var text: String!
    
    private var delegate: EditorViewModelDelegate!

    init(mode: EditorMode, number: Int?, delegate: EditorViewModelDelegate) {
        self.mode = mode
        if let number = number {
            text = String(number)
        }
        self.delegate = delegate
    }
    
    func userAddedNewNumber(text: String?) {
        if let text = text {
            if let newNumber = Int(text) {
                delegate.editorViewModelDelegateAddNumber(self, number: newNumber)
            }
        }
    }
    
    func userChangedSelectedNumber(text: String?) {
        if let text = text {
            if let newNumber = Int(text) {
                delegate.editorViewModelDelegateChangeSelectedNumber(self, newNumber: newNumber)
            }
        }
    }
    
    func userdDeletedSelectedNumber() {
        delegate.editorViewModelDelegateDeleteSelectedNumber(self)
    }
}
