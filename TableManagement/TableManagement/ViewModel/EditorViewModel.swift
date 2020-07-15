//
//  EditorViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct EditorViewModel {
    weak var editorData: EditorData!
    
    func mode() -> CustomEditorViewControllerMode {
        return editorData.mode
    }
    
    func number() -> Int {
        return editorData.number
    }
    
    func text() -> String {
        return String(editorData.number)
    }
    
    func delegate() -> AnyObject! {
        return editorData.delegate
    }
    
    func addNumber() {
        
    }
    
    func changeNumber() {
        
    }
    
    func deleteNumber() {
        
    }
}
