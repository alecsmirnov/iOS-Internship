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
    }
    
    private func applyEditorMode() {
        if let editorViewModel = editorViewModel {
            if let editorMode = editorViewModel.mode {
                switch editorMode {
                case EditorMode.edit:
                    showEditMode()
                    break
                case EditorMode.add:
                    showAddMode()
                    break
                }
            }
        }
        else {
            showAddMode()
        }
    }
    
    private func showEditMode() {
        addButton.isHidden = true
        
        numberField.text = editorViewModel.text
        numberField.textColor = EditorViewController.colorToUIColor(editorViewModel.color)
        
        redColorSlider.value = editorViewModel.color.red * 255.0
        greenColorSlider.value = editorViewModel.color.green * 255.0
        blueColorSlider.value = editorViewModel.color.blue * 255.0
    }
    
    private func showAddMode() {
        editButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    private func slidersColor() -> Color {
        return Color(red: redColorSlider.value / 255.0, green: greenColorSlider.value / 255.0, blue: blueColorSlider.value / 255.0, alpha: 1.0)
    }
    
    private static func colorToUIColor(_ color: Color) -> UIColor {
        return UIColor(red: CGFloat(color.red), green: CGFloat(color.green), blue: CGFloat(color.blue), alpha: CGFloat(color.alpha))
    }
    
    @IBAction private func didTapAdd(_ sender: Any) {
        if let editorViewModel = editorViewModel {
            if let text = numberField.text {
                editorViewModel.userAddedNewNumber(Number(value: Float(text), color: slidersColor()))
                
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
                editorViewModel.userChangedSelectedNumber(Number(value: Float(text), color: slidersColor()))
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
        numberField.textColor = EditorViewController.colorToUIColor(slidersColor())
    }
}
