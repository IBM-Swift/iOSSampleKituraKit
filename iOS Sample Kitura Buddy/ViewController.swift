//
//  ViewController.swift
//  iOS Sample Kitura Buddy
//
//  Created by Shihab Mehboob on 03/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import TypeSafeKituraClient
import TypeSafeContracts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var employeesId: [String] = []
    var employeesName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Kitura Buddy"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        self.tableView = UITableView(frame:CGRect(x:0, y:(self.navigationController?.navigationBar.bounds.height)!, width: self.view.bounds.width, height: (self.navigationController?.view.bounds.height)!))
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func addTapped(button: UIButton) {
        let textEntry = UIAlertController(title: "Text", message: "Please input some text to send:", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            // send to Kitura
            guard let idToSend = textEntry.textFields?[0].text else {return}
            guard let nameToSend = textEntry.textFields?[1].text else {return}
            
            //self.create(textID: idToSend, textName: nameToSend)
            
            self.employeesId.append(idToSend)
            self.employeesName.append(nameToSend)
            self.tableView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        textEntry.addTextField { (textField) in
            textField.placeholder = "ID..."
        }
        textEntry.addTextField { (textField) in
            textField.placeholder = "Name..."
        }
        
        textEntry.addAction(confirm)
        textEntry.addAction(cancel)
        
        self.present(textEntry, animated: true, completion: nil)
    }
    
    // Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeesId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                // Never fails:
                return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        cell.textLabel?.text = self.employeesName[indexPath.row]
        cell.detailTextLabel?.text = self.employeesId[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let textEntry = UIAlertController(title: "Text", message: "Please input the new name for ID \(self.employeesId[indexPath.row]):", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            // send to Kitura
            guard let idToSend = textEntry.textFields?[0].text else {return}
            guard let nameToSend = textEntry.textFields?[1].text else {return}
            
            //self.update(textID: idToSend, textName: nameToSend)
            
            self.tableView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        textEntry.addTextField { (textField) in
            textField.placeholder = "Name..."
        }
        
        textEntry.addAction(confirm)
        textEntry.addAction(cancel)
        
        self.present(textEntry, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.employeesId.remove(at: indexPath.row)
            self.employeesName.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    // Kitura
    /*
     func create(textID: String, textName: String) {
     let newEmployee = Employee(id: textID, name: textName)
     let Emp2 = try Employee.create(model: newEmployee) { (emp: Employee?, error: Error?) -> Void in
     if error != nil {
     XCTFail("Failed to create employee! \(error!)")
     return
     }
     guard let emp = emp else {
     XCTFail("Failed to create employee! \(error!)")
     return
     }
     }
     
     // read into table after creating new item:
     //self.read(i: nil)
     }
     */
    /*
     func read(i: String?) {
     let Emp1 = try Employee.read(id: i?)
     employees.append(Emp1)
     
     self.tableView.reloadData()
     
     // or to read all:
     // let Emp1 = try Employee.read()
     // employees = Emp1
     }
     
     func update(textID: String, textName: String) {
     let Emp1 = Employee(id: textId, name: textName)
     let Emp2 = try Employee.update(id: i, model: Emp1)
     
     // read into table after updating item:
     self.read(i: nil)
     }
     
     func delete(i: String?) {
     try Employee.delete(id: i?)
     
     self.tableView.reloadData()
     
     // or to delete all:
     // try Employee.delete()
     }
     */
}
