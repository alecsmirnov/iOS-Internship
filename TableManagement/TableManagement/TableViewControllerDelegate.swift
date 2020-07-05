//
//  TableViewControllerDelegate.swift
//  TableManagement
//
//  Created by Admin on 05.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate: AnyObject {
    func tableViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int)
    func tableViewControllerDelegateChangeSelectedNumber(_ viewController: UIViewController, newNumber: Int)
    func tableViewControllerDelegateDeleteSelectedNumber(_ viewControllere: UIViewController)
    func tableViewControllerDelegateGetSelectedNumber(_ viewController: UIViewController) -> Int
    func tableViewControllerDelegateGetNumbers(_ viewController: UIViewController) -> [Int]
}
