//
//  EditorViewModelDelegate.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 05.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

protocol EditorViewModelDelegate: AnyObject {
    func editorViewModelDelegateAddNumber(_ viewModel: AnyObject, number: Int)
    func editorViewModelDelegateChangeSelectedNumber(_ viewModel: AnyObject, newNumber: Int)
    func editorViewModelDelegateDeleteSelectedNumber(_ viewModel: AnyObject)
}
