//
//  EditorData.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class EditorData {
    var mode: CustomEditorViewControllerMode!
    weak var delegate: AnyObject!
    var number: Int!
    
    init(mode: CustomEditorViewControllerMode, delegate: AnyObject) {
        self.mode = mode
        self.delegate = delegate
    }
}
