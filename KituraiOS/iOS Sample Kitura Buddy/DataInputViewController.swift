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
    
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var orderField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        hideKeyboard()
    }
    
    @IBAction func pressedDone(_ sender: UIButton) {
        guard let title = titleField.text, let user = userField.text, let order = orderField.text, title != "", user != "",order != "" else{
            let alert = UIAlertController(title: "Could Not Save", message: "One or more fields are not completed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let orderAsInt = Int(order) else{
            let alert = UIAlertController(title: "Not a number", message: "Order was not a number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        create(title: title, user: user, order: orderAsInt)
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
