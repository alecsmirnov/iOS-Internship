//
//  TableViewModelDisplayDelegate.swift
//  TableManagement
//
//  Created by Admin on 27.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol TableViewModelDisplayDelegate: AnyObject {
    func tableViewModelDisplayDelegateReloadRow(_ viewController: AnyObject, at index: Int)
    func tableViewModelDisplayDelegateReloadData(_ viewController: AnyObject)
}
