//
//  NumbersData+GraphViewDataSource.swift
//  TableManagement
//
//  Created by Admin on 30.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

extension NumbersData: GraphViewDataSource {
    func graphViewDataSourceIsEmpty(_ dataSource: AnyObject) -> Bool {
        isEmpty
    }
    
    func graphViewDataSourceCount(_ dataSource: AnyObject) -> Int {
        count
    }
    
    func graphViewDataSourceMin(_ dataSource: AnyObject) -> Float? {
        guard let number = min() else {
            return nil
        }
        
        return number.value
    }
    
    func graphViewDataSourceMax(_ dataSource: AnyObject) -> Float? {
        guard let number = max() else {
            return nil
        }
        
        return number.value
    }
    
    func graphViewDataSourceNumber(_ dataSource: AnyObject, at index: Int) -> Float {
        get(at: index).value
    }
}
