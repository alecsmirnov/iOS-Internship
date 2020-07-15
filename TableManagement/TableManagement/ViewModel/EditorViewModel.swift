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
    private var editorMode: EditorMode!
    private var index: Int!
    private weak var numbersData: NumbersData!
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func setEditorMode(_ editorMode: EditorMode) {
        self.editorMode = editorMode
    }
    
    func setSelectedIndex(_ index: Int) {
        self.index = index
    }
    
    func addNumber(numberString: String) {
        if let number = Int(numberString) {
            numbersData.data.append(number)
        }
    }
    
    func changeSelectedNumber(newNumberString: String) {
        if let index = index {
            guard numbersData.data.indices.contains(index) else {
                fatalError("index is out of range")
            }
            
            if let newNumber = Int(newNumberString) {
                numbersData.data[index] = newNumber
            }
        }
    }
    
    func deleteSelectedNumber() {
        if let index = index {
            guard numbersData.data.indices.contains(index) else {
                fatalError("index is out of range")
            }
            
            numbersData.data.remove(at: index)
        }
    }
    
    func textNumber() -> String {
        guard let index = index else {
            fatalError("index is equal to nul")
        }
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
          
        return String(numbersData.data[index])
    }
    
    func mode() -> EditorMode {
        return editorMode
    }
}
