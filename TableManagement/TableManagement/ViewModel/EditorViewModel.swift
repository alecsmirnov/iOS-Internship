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
    
    var redColorValue: Float {
        return textColor.red * 255.0
    }
    
    var greenColorValue: Float {
        return textColor.green * 255.0
    }
    
    var blueColorValue: Float {
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
    
    func userChangedRedColor(_ value: Float) {
        textColor.red = value / 255.0
    }
    
    func userChangedGreenColor(_ value: Float) {
        textColor.green = value / 255.0
    }
    
    func userChangedBlueColor(_ value: Float) {
        textColor.blue = value / 255.0
    }
    
    func userAddedNewNumber(_ textNumber: String) {
        delegate.editorViewModelDelegateAddNumber(self, number: Number(value: (textNumber as NSString).floatValue, color: textColor))
    }
    
    func userChangedSelectedNumber(_ textNumber: String) {
        delegate.editorViewModelDelegateChangeSelectedNumber(self, newNumber: Number(value: (textNumber as NSString).floatValue, color: textColor))
    }
    
    func userDeletedSelectedNumber() {
        delegate.editorViewModelDelegateDeleteSelectedNumber(self)
    }
    
    func isValidUserInput(text: String, string: String) -> Bool {
        var valid = false
        
        if string.isEmpty {
            valid = true
        }
        
        if !valid {
            let numberMax = 100
            let filtered = string.filter("0123456789".contains)
            
            var integer = abs((text as NSString).integerValue)
            if let firstIndex = text.firstIndex(of: ".") {
                integer = (text[..<firstIndex] as NSString).integerValue
            }
            else {
                if string != "." {
                    integer = integer * 10 + (string as NSString).integerValue
                }
            }
            
            switch string {
            case filtered:
                valid = true
            case ".":
                let dotsCount = text.components(separatedBy: ".").count
                if dotsCount <= 1 && integer < numberMax {
                    valid = true
                }
            case "-":
                let signsCount = text.components(separatedBy: "-").count
                if text.isEmpty && signsCount <= 1 {
                    valid = true
                }
            default:
                valid = false
            }
            
            if numberMax < integer {
                valid = false
            }
        }
        
        return valid
    }
}
