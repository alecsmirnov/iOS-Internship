//
//  EditorViewController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 08.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {
    var number: Int?
    weak var delegate: TableViewControllerDelegate?
    
    private var textFiled: UITextField!
    private var editButton: UIButton!
    private var deleteButton: UIButton!
    
    override func loadView() {
        setupView()
        
        setupTextField()
        setupEditButton()
        setupDeleteButton()
        
        setupTextFieldConstraints()
        setupEditButtonConstraints()
        setupDeleteButtonConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let unwrappedNumber = number {
            textFiled.text = String(unwrappedNumber)
        }
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
    
    private func setupEditButton() {
        let width: CGFloat = 50
        let height: CGFloat = 30
        
        editButton = UIButton(type: .system)
        
        editButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(didPressEdit(_:)), for: .touchUpInside)
        
        view.addSubview(editButton)
    }
    
    private func setupDeleteButton() {
        let width: CGFloat = 50
        let height: CGFloat = 30
        
        deleteButton = UIButton(type: .system)
        
        deleteButton.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(didPressDelete(_:)), for: .touchUpInside)
        
        view.addSubview(deleteButton)
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
    
    private func setupEditButtonConstraints() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: editButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: editButton.frame.width)
        let heigtConstraint = NSLayoutConstraint(item: editButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: editButton.frame.height)
        let horizontalConstraint = NSLayoutConstraint(item: editButton!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 50)
        let verticalConstraint = NSLayoutConstraint(item: editButton!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        let constraints = [widthConstraint, heigtConstraint, horizontalConstraint, verticalConstraint]
        
        view.addConstraints(constraints)
    }
    
    private func setupDeleteButtonConstraints() {
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: deleteButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: deleteButton.frame.width)
        let heigtConstraint = NSLayoutConstraint(item: deleteButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: deleteButton.frame.height)
        let horizontalConstraint = NSLayoutConstraint(item: deleteButton!, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 100)
        let verticalConstraint = NSLayoutConstraint(item: deleteButton!, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        let constraints = [widthConstraint, heigtConstraint, horizontalConstraint, verticalConstraint]
        
        view.addConstraints(constraints)
    }
    
    @objc func didPressEdit(_ sender : UIButton) {
        if let unwrappedDelegate = delegate {
            unwrappedDelegate.tableViewControllerDelegateChangeSelectedNumber(self, newNumber: Int(textFiled.text!)!)
        }
    }
    
    @objc func didPressDelete(_ sender : UIButton) {
        if let unwrappedDelegate = delegate {
            unwrappedDelegate.tableViewControllerDelegateDeleteSelectedNumber(self)
            
            navigationController!.popViewController(animated: true);
        }
    }
}
