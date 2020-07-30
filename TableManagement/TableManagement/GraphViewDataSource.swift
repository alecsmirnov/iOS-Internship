//
//  GraphViewDataSource.swift
//  TableManagement
//
//  Created by Admin on 30.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol GraphViewDataSource: AnyObject {
    func graphViewDataSourceIsEmpty(_ dataSource: AnyObject) -> Bool
    func graphViewDataSourceCount(_ dataSource: AnyObject) -> Int
    func graphViewDataSourceMin(_ dataSource: AnyObject) -> Float?
    func graphViewDataSourceMax(_ dataSource: AnyObject) -> Float?
    func graphViewDataSourceNumber(_ dataSource: AnyObject, at index: Int) -> Float
}
