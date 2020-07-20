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
    var color: Color!
    
    private var delegate: EditorViewModelDelegate!

    init(mode: EditorMode, number: Number?, delegate: EditorViewModelDelegate) {
        self.mode = mode
        if let number = number {
            text = String(number.value)
            color = number.color
        }
        self.delegate = delegate
    }
    
    func userAddedNewNumber(_ number: Number) {
        delegate.editorViewModelDelegateAddNumber(self, number: number)
    }
    
    func userChangedSelectedNumber(_ number: Number) {
        delegate.editorViewModelDelegateChangeSelectedNumber(self, newNumber: number)
    }
    
    func userDeletedSelectedNumber() {
        delegate.editorViewModelDelegateDeleteSelectedNumber(self)
    }
}
