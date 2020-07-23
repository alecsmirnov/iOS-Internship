//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    var editorViewModel: EditorViewModel!

    @IBOutlet private var numberField: UITextField!
    
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var deleteButton: UIButton!
    
    @IBOutlet private var redColorSlider: UISlider!
    @IBOutlet private var greenColorSlider: UISlider!
    @IBOutlet private var blueColorSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyEditorMode()
        
        numberField.delegate = self
    }
    
    private func applyEditorMode() {
        if let editorViewModel = editorViewModel {
            switch editorViewModel.mode {
            case EditorMode.edit:
                showEditMode()
                break
            case EditorMode.add:
                showAddMode()
                break
            }
        }
        else {
            showAddMode()
        }
    }
    
    private func showEditMode() {
        addButton.isHidden = true
        
        numberField.text = editorViewModel.text
        if let color = editorViewModel.color {
             numberField.textColor = UIColor(color)
        }
       
        redColorSlider.value = Float(editorViewModel.color.redInt)
        greenColorSlider.value = Float(editorViewModel.color.greenInt)
        blueColorSlider.value = Float(editorViewModel.color.blueInt)
    }
    
    private func showAddMode() {
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    private func slidersColor() -> Color {
        return Color(red: Int(redColorSlider.value), green: Int(greenColorSlider.value), blue: Int(blueColorSlider.value))
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if let text = numberField.text {
                editorViewModel.userAddedNewNumber(Number(value: (text as NSString).floatValue, color: slidersColor()))
                
                numberField.text = ""
                
                redColorSlider.value = 0
                greenColorSlider.value = 0
                blueColorSlider.value = 0
            }
        }
    }
    
    @IBAction private func didTapEdit(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if let text = numberField.text {
                editorViewModel.userChangedSelectedNumber(Number(value: (text as NSString).floatValue, color: slidersColor()))
            }
        }
    }
    
    @IBAction private func didTapDelete(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.userDeletedSelectedNumber()
            
            navigationController!.popViewController(animated: true);
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
    
    @IBAction private func didSlideColor(_ sender: Any) {
        numberField.textColor = UIColor(slidersColor())
    }
}

extension EditorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isValid = false
        
        if string.isEmpty {
            isValid = true
        }
        
        guard let text = textField.text else {
            return false
        }
        
        if !isValid {
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
                isValid = true
            case ".":
                let dotsCount = text.components(separatedBy: ".").count
                if dotsCount <= 1 && integer < numberMax {
                    isValid = true
                }
            case "-":
                let signsCount = text.components(separatedBy: "-").count
                if text.isEmpty && signsCount <= 1 {
                    isValid = true
                }
            default:
                isValid = false
            }
            
            if numberMax < integer {
                isValid = false
            }
        }
        
        return isValid
    }
}
