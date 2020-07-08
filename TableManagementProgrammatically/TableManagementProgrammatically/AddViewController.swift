//
//  AddViewController.swift
//  TableManagementProgrammatically
//
//  Created by Admin on 06.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: TableViewControllerDelegate?
    
    private var textFiled: UITextField!
    private var addButton: UIButton!
    
    override func loadView() {
        setupView()
        setupTextField()
        setupAddButton()
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
        
        textFiled.frame = CGRect(x: view.frame.width / 2 - 70, y: view.frame.height / 2, width: width, height: height)
        textFiled.borderStyle = .roundedRect
        
        view.addSubview(textFiled)
    }
    
    private func setupAddButton() {
        let width: CGFloat = 50
        let height: CGFloat = 30
        
        addButton = UIButton(type: .system)
        
        addButton.frame = CGRect(x: view.frame.width / 2 + 30, y: view.frame.height / 2, width: width, height: height)
        
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(didPressAdd(_:)), for: .touchUpInside)
        
        view.addSubview(addButton)
    }
    
    @objc func didPressAdd(_ sender : UIButton) {
        if let unwrappedDelegate = delegate {
            if !textFiled.text!.isEmpty {
                unwrappedDelegate.tableViewControllerDelegateAddNumber(self, number: Int(textFiled.text!)!)
                
                textFiled.text = ""
            }
        }
    }
}
