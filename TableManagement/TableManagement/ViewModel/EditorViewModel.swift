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
    var numberString: String!
    
    private var delegate: EditorViewModelDelegate!

    init(mode: EditorMode, number: Int?, delegate: EditorViewModelDelegate) {
        self.mode = mode
        if let number = number {
            numberString = String(number)
        }
        else {
            numberString = ""
        }
        self.delegate = delegate
    }
    
    func userAddedNewNumber(newNumberString: String?) {
        if let newNumberString = newNumberString {
            if let newNumber = Int(newNumberString) {
                delegate.editorViewModelDelegateAddNumber(self, number: newNumber)
            }
        }
    }
    
    func userChangedSelectedNumber(newNumberString: String?) {
        if let newNumberString = newNumberString {
            if let newNumber = Int(newNumberString) {
                delegate.editorViewModelDelegateChangeSelectedNumber(self, newNumber: newNumber)
            }
        }
    }
    
    func userdDeletedSelectedNumber() {
        delegate.editorViewModelDelegateDeleteSelectedNumber(self)
    }
}
