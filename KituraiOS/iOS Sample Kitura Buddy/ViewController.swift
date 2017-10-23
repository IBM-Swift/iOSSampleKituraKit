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
    lazy var searchBar:UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        self.tableView = UITableView(frame:CGRect(x:0, y:(self.navigationController?.navigationBar.bounds.height)!, width: self.view.bounds.width, height: (self.navigationController?.view.bounds.height)!))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        
        searchBar.frame = CGRect(x: 0, y: 64, width: self.view.bounds.width, height: searchBar.bounds.height)
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.readAll()
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchString = searchBar.text else {
            return
        }
        guard let searchInt = Int(searchString) else {
            return
        }
        let searchIntChanged = searchInt - 1
        
        let searchStringToSend = String(searchIntChanged)
        
        self.read(Id: searchStringToSend)
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localToDo.localToDoStore.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        /*var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value2, reuseIdentifier: "Cell")
        }*/
        
        guard let title = localToDo.localToDoStore[indexPath.row].title else {return cell}
        guard let user = localToDo.localToDoStore[indexPath.row].user else {return cell}
        guard let order = localToDo.localToDoStore[indexPath.row].order else {return cell}
        guard let textLabel = cell.textLabel else {return cell}
        textLabel.text = "\(order) - \(title) by \(user)"
        guard let detailTextLabel = cell.detailTextLabel else {return cell}
        detailTextLabel.text = "\(order)"
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        guard let url = localToDo.localToDoStore[indexPath.row].url else {return}
        
        let textEntry = UIAlertController(title: "Text", message: "Please input new data", preferredStyle: .alert)
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
