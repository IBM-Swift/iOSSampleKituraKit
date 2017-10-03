//
//  ViewController.swift
//  iOS Sample Kitura Buddy
//
//  Created by Shihab Mehboob on 03/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Kitura Buddy"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        self.tableView = UITableView(frame:CGRect(x:0, y:(self.navigationController?.navigationBar.bounds.height)!, width: self.view.bounds.width, height: (self.navigationController?.view.bounds.height)!))
        self.tableView.backgroundColor = UIColor.white
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @objc func addTapped(button: UIButton) {
        let textEntry = UIAlertController(title: "Text", message: "Please input some text to send:", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = textEntry.textFields?[0] {
                // send to Kitura
            } else {
                
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        textEntry.addTextField { (textField) in
            textField.placeholder = "Text..."
        }
        
        textEntry.addAction(confirm)
        textEntry.addAction(cancel)
        
        self.present(textEntry, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}

