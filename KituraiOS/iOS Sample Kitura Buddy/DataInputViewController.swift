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

import Foundation
import KituraBuddy
import UIKit


class DataInputViewController: ViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        titleField.becomeFirstResponder()
    }
    
    @IBAction func pressedDone(_ sender: UIButton) {
        
        // Infer the order field from the placement of the cell in the table view
        
        let orderText = String(localToDo.localToDoStore.count + 1)
        
        // Populate the title and user fields to send from the respective fields in the view
        
        guard let title = titleField.text, let user = userField.text, title != "", user != "" else{
            let alert = UIAlertController(title: "Could Not Save", message: "One or more fields are not completed", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let orderAsInt = Int(orderText) else{
            let alert = UIAlertController(title: "Not a number", message: "Order was not a number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        // Call the create method with the respective fields, and head back to the main screen
        
        self.create(title: title, user: user, order: orderAsInt)
        self.performSegue(withIdentifier: "unwindToList", sender: self)
    }
    
}


