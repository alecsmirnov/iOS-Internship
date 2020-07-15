//
//  EditorViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class EditorViewModel {
    private weak var editorData: EditorData!
    
    init(editorData: EditorData) {
        self.editorData = editorData
    }
    
    func setMode(mode: CustomEditorViewControllerMode) {
        editorData.mode = mode
    }
    
    func setNumber(number: Int) {
        editorData.number = number
    }
    
    func mode() -> CustomEditorViewControllerMode {
        return editorData.mode
    }

    func text() -> String {
        var textNumber = ""
        
        if let number = editorData.number {
            textNumber = String(number)
        }
        
        return textNumber
    }
    
    func addNumber(_ viewController: AnyObject, number: Int) {
        let delegate = editorData.delegate as! EditorViewControllerDelegate
        delegate.editorViewControllerDelegateAddNumber(viewController, number: number)
    }
    
    func changeNumber(_ viewController: AnyObject, newNumber: Int) {
        let delegate = editorData.delegate as! EditorViewControllerDelegate
        delegate.editorViewControllerDelegateChangeSelectedNumber(viewController, newNumber: newNumber)
    }
    
    func deleteNumber(_ viewController: AnyObject) {
        let delegate = editorData.delegate as! EditorViewControllerDelegate
        delegate.editorViewControllerDelegateDeleteSelectedNumber(viewController)
    }
}
