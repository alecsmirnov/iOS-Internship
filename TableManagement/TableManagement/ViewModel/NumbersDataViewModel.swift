//
//  NumbersDataViewModel.swift
//  TableManagement
//
//  Created by Admin on 14.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class NumbersDataViewModel {
    weak private var numbersData: NumbersData! {
        didSet {
            cellViewModels.removeAll()
            
            for number in numbersData.data {
                cellViewModels.append(CellViewModel(number: number))
            }
        }
    }
    
    private var cellViewModels: [CellViewModel] = []
    private var editorViewModel: EditorViewModel!
    private var statisticsViewModel: StatisticsViewModel!
    
    func cellViewModel(at index: Int) -> CellViewModel {
        guard cellViewModels.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        return cellViewModels[index]
    }
    
    func editorViewModel(_ delegate: EditorViewControllerDelegate, mode: CustomEditorViewControllerMode, at index: Int) -> EditorViewModel {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        return EditorViewModel(delegate: delegate, mode: mode, number: numbersData.data[index])
    }
    
    func isEmpty() -> Bool {
        return numbersData.data.isEmpty
    }
    
    func append(number: Int) {
        numbersData.data.append(number)
    }
    
    func remove(at index: Int) {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        numbersData.data.remove(at: index)
    }
    
    func replace(at index: Int, with number: Int) {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        numbersData.data[index] = number
    }

    func get(at index: Int) -> Int {
        guard numbersData.data.indices.contains(index) else {
            fatalError("index is out of range")
        }
        
        return numbersData.data[index]
    }
    
    func count() -> Int {
        return numbersData.data.count
    }
        
    func min() ->Int? {
        return numbersData.data.min()
    }
    
    func max() ->Int? {
        return numbersData.data.max()
    }
    
    func average() -> Double? {
        return numbersData.data.isEmpty ? Double(numbersData.data.reduce(0, +)) / Double(numbersData.data.count) : nil
    }
    
    deinit {
        cellViewModels.removeAll()
    }
}
