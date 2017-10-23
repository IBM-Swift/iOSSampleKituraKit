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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let client = KituraBuddy(baseURL: "http://localhost:8080")
    public var tableView: UITableView = UITableView()
    public let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        self.tableView = UITableView(frame:CGRect(x:0, y:(self.navigationController?.navigationBar.bounds.height)!, width: self.view.bounds.width, height: (self.navigationController?.view.bounds.height)!))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let deleteButton = UIButton(frame:CGRect(x: self.view.bounds.width/2 - 60,y: self.view.bounds.height - 70, width: 120, height: 40))
        deleteButton.setTitle("Delete All", for: .normal)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        deleteButton.layer.cornerRadius = 20
        deleteButton.backgroundColor = UIColor.red
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchDown)
        self.view.addSubview(deleteButton)
        
        
    }
    
    @objc func deleteTapped() {
        self.deleteAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.readAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.dismiss(animated: true, completion: nil)
        guard let searchString = searchController.searchBar.text else {
            return
        }
        guard let searchInt = Int(searchString) else {
            return
        }
        let searchIntChanged = searchInt - 1
        let searchStringToSend = String(searchIntChanged)
        self.read(Id: searchStringToSend)
        searchController.resignFirstResponder()
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localToDo.localToDoStore.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        guard let title = localToDo.localToDoStore[indexPath.row].title else {return cell}
        let user = localToDo.localToDoStore[indexPath.row].user ?? "Test User"
        guard let order = localToDo.localToDoStore[indexPath.row].order else {return cell}
        guard let textLabel = cell.textLabel else {return cell}
        textLabel.text = "\(order) - \(title) by \(user)"
        
        for item in localToDo.localToDoStore {
            if item.completed == true {
                self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
            } else {
                self.tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
            }
        }
        
        
        if localToDo.localToDoStore[indexPath.row].completed == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let completed = UIContextualAction(style: .normal, title: "Mark as completed") { action, view, completionHandler in
            print("Marking as completed")
            guard let url = localToDo.localToDoStore[indexPath.row].url else {return}
            let orderToSend:Int = indexPath.row + 1
            let titleToSend:String? = localToDo.localToDoStore[indexPath.row].title
            let userToSend:String? = localToDo.localToDoStore[indexPath.row].user
            self.update(title: titleToSend, user: userToSend, order: orderToSend, completed: true, url: url)
            self.tableView.reloadData()
            completionHandler(true)
        }
        completed.backgroundColor = UIColor(red: 10/255, green:200/255, blue:10/255, alpha:1)
        
        return UISwipeActionsConfiguration(actions: [completed])
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = localToDo.localToDoStore[indexPath.row].url else {return}
        let textEntry = UIAlertController(title: "Edit ToDo", message: "Please input new data", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Confirm", style: .default) { (_) in
            
            let orderToSend:Int = indexPath.row + 1
            var titleToSend:String? = textEntry.textFields?[0].text
            var userToSend:String? = textEntry.textFields?[1].text
            if titleToSend == "" {titleToSend = nil}
            if userToSend == "" {userToSend = nil}
            self.update(title: titleToSend, user: userToSend, order: orderToSend, completed: nil, url: url)
            self.tableView.reloadData()
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        textEntry.addTextField { (textField) in
            textField.placeholder = "Title..."
        }
        textEntry.addTextField { (textField) in
            textField.placeholder = "User..."
        }
        
        textEntry.addAction(confirm)
        textEntry.addAction(cancel)
        
        self.present(textEntry, animated: true, completion: nil)
        
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            guard let url = localToDo.localToDoStore[indexPath.row].url else {return}
            self.delete(url: url)
            localToDo.localToDoStore.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
    
}

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        ViewController().tableView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
