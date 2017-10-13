//
//  ViewController.swift
//  iOS Sample Kitura Buddy
//
//  Created by Shihab Mehboob on 03/10/2017.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import KituraBuddy
import TypeSafeContracts

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var employeesId: [String] = []
    var employeesName: [String] = []
    var chosenSegment = 0
    
    let client = KituraBuddy(baseURL: "http://localhost:8080")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "Kitura Buddy"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        let segment: UISegmentedControl = UISegmentedControl(items: ["Basic Type Safe Routing", "CRUD API Routing"])
        segment.sizeToFit()
        segment.tintColor = UIColor.blue
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        self.navigationItem.titleView = segment
        
        self.tableView = UITableView(frame:CGRect(x:0, y:(self.navigationController?.navigationBar.bounds.height)!, width: self.view.bounds.width, height: (self.navigationController?.view.bounds.height)!))
        self.tableView.backgroundColor = UIColor.white
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if (segment.selectedSegmentIndex) == 0 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
            self.read()
            self.chosenSegment = 0
        } else if (segment.selectedSegmentIndex) == 1 {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTappedCRUD))
            self.readCRUD()
            self.chosenSegment = 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            let idToSend = self.employeesId[indexPath.row]
            guard let nameToSend = textEntry.textFields?[0].text else {return}
            
            self.update(textID: idToSend, textName: nameToSend)
            
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
            if self.chosenSegment == 0 {
                self.delete(textID: self.employeesId[indexPath.row])
                
                self.employeesId.remove(at: indexPath.row)
                self.employeesName.remove(at: indexPath.row)
                
                self.tableView.reloadData()
            } else if self.chosenSegment == 1 {
                
                self.deleteCRUD(textID: self.employeesId[indexPath.row])
                
                self.employeesId.remove(at: indexPath.row)
                self.employeesName.remove(at: indexPath.row)
                
                self.tableView.reloadData()
            }
        }
    }
    
    // Basic Type Safe Routing Methods
    
    @objc func addTapped(button: UIButton) {
        print("basic")
        let textEntry = UIAlertController(title: "Text", message: "Please input some text to send:", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            // send to Kitura
            guard let idToSend = textEntry.textFields?[0].text else {return}
            guard let nameToSend = textEntry.textFields?[1].text else {return}
            
            self.employeesId.append(idToSend)
            self.employeesName.append(nameToSend)
            
            self.create(textID: idToSend, textName: nameToSend)
            
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
    
    func create(textID: String, textName: String) {
        
        let newUser = User(id: Int(textID)!, name: textName)
        self.client.post("/users", data: newUser) { (user: User?, error: Error?) -> Void in
            guard let _ = user else {
                return
            }
        }
        
        self.read()
    }
    
    func read() {
        self.client.get("/users") { (users: [User]?, error: Error?) -> Void in
            guard let _ = users else {
                return
            }
            
            self.tableView.reloadData()
        }
    }
    
    func update(textID: String, textName: String) {
        let expectedUser = User(id: Int(textID)!, name: textName)
        print(Int(textID)!)
        client.put("/users", identifier: String(expectedUser.id), data: expectedUser) { (user: User?, error: Error?) -> Void in
            guard let _ = user else {
                return
            }
        }
    }
    
    func delete(textID: String) {
        client.delete("/users", identifier: Int(textID)!) { error in
            guard error == nil else {
                return
            }
        }
    }
    
    // CRUD API Routing Methods
    
    @objc func addTappedCRUD(button: UIButton) {
        print("CRUD")
        let textEntry = UIAlertController(title: "Text", message: "Please input some text to send:", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            // send to Kitura
            guard let idToSend = textEntry.textFields?[0].text else {return}
            guard let nameToSend = textEntry.textFields?[1].text else {return}
            
            self.createCRUD(textID: idToSend, textName: nameToSend)
            
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
    
    func createCRUD(textID: String, textName: String) {
        /*
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
         */
        self.readCRUD()
    }
    
    func readCRUD() {
        /*
         let Emp1 = try Employee.read()
         employees = Emp1
         self.tableView.reloadData()
         */
    }
    
    func updateCRUD(textID: String, textName: String) {
        /*
         let Emp1 = Employee(id: textId, name: textName)
         let Emp2 = try Employee.update(id: i, model: Emp1)
         */
        self.readCRUD()
    }
    
    func deleteCRUD(textID: String) {
        /*
         try Employee.delete(id: Int(textID)!)
         self.tableView.reloadData()
         */
    }
    
}
