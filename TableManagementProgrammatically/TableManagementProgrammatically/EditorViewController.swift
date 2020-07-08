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
        
        textFiled.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2, width: width, height: height)
        textFiled.borderStyle = .roundedRect
        
        view.addSubview(textFiled)
    }
    
    private func setupEditButton() {
        let width: CGFloat = 50
        let height: CGFloat = 30
        
        editButton = UIButton(type: .system)
        
        editButton.frame = CGRect(x: view.frame.width / 2 + 10, y: view.frame.height / 2, width: width, height: height)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(didPressEdit(_:)), for: .touchUpInside)
        
        view.addSubview(editButton)
    }
    
    private func setupDeleteButton() {
        let width: CGFloat = 50
        let height: CGFloat = 30
        
        editButton = UIButton(type: .system)
        
        editButton.frame = CGRect(x: view.frame.width / 2 + 60, y: view.frame.height / 2, width: width, height: height)
        
        editButton.setTitle("Delete", for: .normal)
        editButton.addTarget(self, action: #selector(didPressDelete(_:)), for: .touchUpInside)
        
        view.addSubview(editButton)
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
