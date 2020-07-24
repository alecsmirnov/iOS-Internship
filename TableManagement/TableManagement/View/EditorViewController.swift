//
//  AddViewController.swift
//  TableManagement
//
//  Created by Admin on 03.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private enum SlidersTag {
    static let redColor   = 0
    static let greenColor = 1
    static let blueColor  = 2
}

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
        numberField.textColor = UIColor(editorViewModel.textColor)
       
        redColorSlider.value = editorViewModel.redColorValue
        greenColorSlider.value = editorViewModel.greenColorValue
        blueColorSlider.value = editorViewModel.blueColorValue
    }
    
    private func showAddMode() {
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if let text = numberField.text {
                editorViewModel.userAddedNewNumber(text)
                
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
                editorViewModel.userChangedSelectedNumber(text)
            }
        }
    }
    
    @IBAction private func didTapDelete(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            editorViewModel.userDeletedSelectedNumber()
            
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true);
            }
        }
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
    
    @IBAction private func didSlideColor(_ sender: Any) {
        let slider = sender as! UISlider
        
        switch slider.tag {
        case SlidersTag.redColor:
            editorViewModel.userChangedRedColor(redColorSlider.value)
            break
        case SlidersTag.greenColor:
            editorViewModel.userChangedGreenColor(greenColorSlider.value)
            break
        case SlidersTag.blueColor:
            editorViewModel.userChangedBlueColor(blueColorSlider.value)
            break
        default:
            break
        }
        
        numberField.textColor = UIColor(editorViewModel.textColor)
    }
}

extension EditorViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var validInput = false
        
        if let text = textField.text {
            validInput = editorViewModel.isValidUserInput(text: text, string: string)
        }
        
        return validInput
    }
}
