//
//  TableViewControllerDelegate.swift
//  TableManagement
//
//  Created by Admin on 05.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol EditorViewControllerDelegate: AnyObject {
    func editorViewControllerDelegateAddNumber(_ viewController: AnyObject, number: Int)
    func editorViewControllerDelegateChangeSelectedNumber(_ viewController: AnyObject, newNumber: Int)
    func editorViewControllerDelegateDeleteSelectedNumber(_ viewControllere: AnyObject)
}
