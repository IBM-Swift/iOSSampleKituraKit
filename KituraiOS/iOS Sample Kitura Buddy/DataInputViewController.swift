//
//  DataInputViewController.swift
//  iOS Sample Kitura Buddy
//
//  Created by Kye Maloy on 19/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import KituraBuddy
import UIKit


class DataInputViewController: ViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var completedToggle: UISwitch!
    @IBOutlet weak var orderField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        hideKeyboard()
    }
    
    @IBAction func pressedDone(_ sender: UIButton) {
        tableView.reloadData()
        self.performSegue(withIdentifier: "unwindToList", sender: self)
    }
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
