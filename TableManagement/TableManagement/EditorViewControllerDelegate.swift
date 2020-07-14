//
//  TableViewControllerDelegate.swift
//  TableManagement
//
//  Created by Admin on 05.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol EditorViewControllerDelegate: AnyObject {
    func editorViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int)
    func editorViewControllerDelegateChangeSelectedNumber(_ viewController: UIViewController, newNumber: Int)
    func editorViewControllerDelegateDeleteSelectedNumber(_ viewControllere: UIViewController)
}
