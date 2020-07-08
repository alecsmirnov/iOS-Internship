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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white 
    }

}
