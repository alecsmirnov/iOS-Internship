//
//  NumbersDataViewModel.swift
//  TableManagement
//
//  Created by Admin on 14.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class TableViewModel {
    //var count: Int!
    
    private var numbersData: NumbersData!
    private var selectedRow: Int?
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func count() -> Int {
        return numbersData.count()
    }
    
    func editorViewModel(at index: Int) -> EditorViewModel {
        selectedRow = index
        
        return EditorViewModel(mode: EditorMode.edit, number: numbersData.get(at: index), delegate: self)
    }
    
    func cellViewModel(at index: Int) -> CellViewModel {
        return CellViewModel(number: numbersData.get(at: index))
    }
}

extension TableViewModel: EditorViewModelDelegate {
    func editorViewModelDelegateAddNumber(_ viewModel: AnyObject, number: Int) {
        numbersData.append(number: number)
    }
    
    func editorViewModelDelegateChangeSelectedNumber(_ viewModel: AnyObject, newNumber: Int) {
        guard let selectedRow = selectedRow else {
            fatalError("Row are not specified")
        }
        
        numbersData.replace(at: selectedRow, with: newNumber)
    }
    
    func editorViewModelDelegateDeleteSelectedNumber(_ viewModel: AnyObject) {
        guard let selectedRow = selectedRow else {
            fatalError("Row are not specified")
        }
        
        numbersData.remove(at: selectedRow)
    }
}
