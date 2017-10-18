/*
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import KituraBuddy

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView = UITableView()
    var employeesId: [String] = []
    var employeesName: [String] = []
    
    let client = KituraBuddy(baseURL: "http://localhost:8080")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "To Do List Type Safe Routing"
        
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
        let textEntry = UIAlertController(title: "Text", message: "Please input the new task for ID \(self.employeesId[indexPath.row]):", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            // send to Kitura
            let idToSend = self.employeesId[indexPath.row]
            guard let nameToSend = textEntry.textFields?[0].text else {return}
            
            self.update(textID: idToSend, textName: nameToSend)
            
            self.tableView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        textEntry.addTextField { (textField) in
            textField.placeholder = "Task..."
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
            
            self.delete(textID: self.employeesId[indexPath.row])
            
            self.employeesId.remove(at: indexPath.row)
            self.employeesName.remove(at: indexPath.row)
            
            self.tableView.reloadData()
            
        }
    }
    
    @objc func addTapped(button: UIButton) {
        print("basic")
        let textEntry = UIAlertController(title: "Text", message: "Please input a new task:", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            // send to Kitura
            guard let idToSend = textEntry.textFields?[0].text else {return}
            guard let nameToSend = textEntry.textFields?[1].text else {return}
            print("idToSend: \(idToSend) nameToSend \(nameToSend)")
            self.employeesId.append(idToSend)
            self.employeesName.append(nameToSend)
            print("employeeID: \(self.employeesId) employeesName \(self.employeesName)")
            self.create(textID: idToSend, textName: nameToSend)
            
            self.tableView.reloadData()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        textEntry.addTextField { (textField) in
            textField.placeholder = "ID..."
        }
        textEntry.addTextField { (textField) in
            textField.placeholder = "Task..."
        }
        textEntry.addAction(confirm)
        textEntry.addAction(cancel)
        
        self.present(textEntry, animated: true, completion: nil)
    }
}
