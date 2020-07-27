//
//  NumbersDataViewModel.swift
//  TableManagement
//
//  Created by Admin on 14.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class TableViewModel {
    var count: Int {
        return numbersData.count
    }
    
    var delegate: TableViewModelDisplayDelegate!
    
    private var numbersData: NumbersData
    private var selectedRow: Int?
    
    init(numbersData: NumbersData) {
        self.numbersData = numbersData
    }
    
    func userDeletedNumber(at index: Int) {
        numbersData.remove(at: index)
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
    func editorViewModelDelegateAddNumber(_ viewModel: AnyObject, number: Number) {
        numbersData.append(number: number)
        
        if let delegate = delegate {
            delegate.tableViewModelDisplayDelegateUpdateTable(self)
        }
    }
    
    func editorViewModelDelegateChangeSelectedNumber(_ viewModel: AnyObject, newNumber: Number) {
        guard let selectedRow = selectedRow else {
            fatalError("Row are not specified")
        }
        
        numbersData.replace(at: selectedRow, with: newNumber)
        
        if let delegate = delegate {
            delegate.tableViewModelDisplayDelegateUpdateNumber(self, at: selectedRow)
        }
    }
    
    func editorViewModelDelegateDeleteSelectedNumber(_ viewModel: AnyObject) {
        guard let selectedRow = selectedRow else {
            fatalError("Row are not specified")
        }
        
        numbersData.remove(at: selectedRow)
        
        if let delegate = delegate {
            delegate.tableViewModelDisplayDelegateUpdateTable(self)
        }
    }
}
