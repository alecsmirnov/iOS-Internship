//
//  EditorViewModel.swift
//  TableManagement
//
//  Created by Admin on 15.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

enum EditorMode {
    case edit
    case add
}

class EditorViewModel {
    var mode: EditorMode
    
    var text: String?
    var textColor: Color
    
    var redColorSliderValue: Float {
        return textColor.red * 255.0
    }
    
    var greenColorSliderValue: Float {
        return textColor.green * 255.0
    }
    
    var blueColorSliderValue: Float {
        return textColor.blue * 255.0
    }
    
    private var delegate: EditorViewModelDelegate!
    
    init(mode: EditorMode, number: Number?, delegate: EditorViewModelDelegate) {
        self.mode = mode
        
        if let number = number {
            text = String(number.value)
            textColor = number.color
        }
        else {
            textColor = Color(red: 0, green: 0, blue: 0)
        }
        
        self.delegate = delegate
    }
    
    func userChangedRedColorSlider(_ value: Float) {
        textColor.red = value / 255.0
    }
    
    func userChangedGreenColorSlider(_ value: Float) {
        textColor.green = value / 255.0
    }
    
    func userChangedBlueColorSlider(_ value: Float) {
        textColor.blue = value / 255.0
    }
    
    func userAddedNewNumber(_ text: String) {
        delegate.editorViewModelDelegateAddNumber(self, number: Number(value: (text as NSString).floatValue, color: textColor))
        
        textColor = Color(red: 0, green: 0, blue: 0)
    }
    
    func userChangedSelectedNumber(_ text: String) {
        delegate.editorViewModelDelegateChangeSelectedNumber(self, newNumber: Number(value: (text as NSString).floatValue, color: textColor))
    }
    
    func userDeletedSelectedNumber() {
        delegate.editorViewModelDelegateDeleteSelectedNumber(self)
    }
}
