//
//  AddViewController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol AddViewControllerDelegate: AnyObject {
    func addViewControllerDelegateAddNumber(_ viewController: UIViewController, number: Int)
}

class AddViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: AddViewControllerDelegate?
    
    private var textFiled: UITextField!
    private var addButton: UIButton!
    
    override func loadView() {
        setupView()
        
        setupTextField()
        setupAddButton()
        
        setupTextFieldConstraints()
        setupAddButtonConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setupView() {
        view = UIView()
        
        view.frame = UIScreen.main.bounds
        view.backgroundColor = .white
    }
    
    private func setupTextField() {
        let width: CGFloat = 100
        let height: CGFloat = 30
        
        textFiled = UITextField()
        
        textFiled.frame = CGRect(x: 0, y: 0, width: width, height: height)
        textFiled.borderStyle = .roundedRect
        
        view.addSubview(textFiled)
    }
    
    private func setupAddButton() {
        let width: CGFloat = 50
        let height: CGFloat = 30
        
        addButton = UIButton(type: .system)
        
        addButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(didPressAdd(_:)), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
    private func setupTextFieldConstraints() {
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: textFiled!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: textFiled.frame.width)
        let heigtConstraint = NSLayoutConstraint(item: textFiled!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: textFiled.frame.height)
        let horizontalConstraint = NSLayoutConstraint(item: textFiled!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: -30)
        let verticalConstraint = NSLayoutConstraint(item: textFiled!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        let constraints = [widthConstraint, heigtConstraint, horizontalConstraint, verticalConstraint]
        
        view.addConstraints(constraints)
    }
    
    private func setupAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: addButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: addButton.frame.width)
        let heigtConstraint = NSLayoutConstraint(item: addButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: addButton.frame.height)
        let horizontalConstraint = NSLayoutConstraint(item: addButton!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 50)
        let verticalConstraint = NSLayoutConstraint(item: addButton!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        let constraints = [widthConstraint, heigtConstraint, horizontalConstraint, verticalConstraint]
        
        view.addConstraints(constraints)
    }
    
    @objc func didPressAdd(_ sender : UIButton) {
        if let unwrappedDelegate = delegate {
            if !textFiled.text!.isEmpty {
                unwrappedDelegate.addViewControllerDelegateAddNumber(self, number: Int(textFiled.text!)!)
                
                textFiled.text = ""
            }
        }
    }
}
