//
//  DetailViewController.swift
//  TableManagement
//
//  Created by Admin on 01.07.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {  
    private weak var delegate: TableViewControllerDelegate?
    
    @IBOutlet private var numberField: UITextField!
    
    func setDelegate(delegate: TableViewControllerDelegate) {
        self.delegate = delegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        numberField.text = String(delegate!.selectedNumber())
    }
    
    @IBAction private func didPressEdit(_ sender: UIButton) {
        delegate!.didChangeNumber(newNumber: Int(numberField.text!)!)
    }
    
    @IBAction private func didPressDelete(_ sender: UIButton) {
        delegate!.didDeleteNumber()
        
        navigationController?.popViewController(animated: true);
    }
    
    @IBAction private func didTouchScreen(_ sender: UITapGestureRecognizer) {
        numberField.resignFirstResponder()
    }
}
