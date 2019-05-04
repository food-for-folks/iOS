//
//  TableViewControllerMessages.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 5/3/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase

class TableViewControllerMessages: UITableViewController {

    var threads = [String]()
    var owner  = [String]()
    var uid = [String]()
    var pNum = [Int]()
    var selected:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).child("food").observe(.value) { (snapshot) in
            if(snapshot.value != nil) {
                self.owner.removeAll()
                self.pNum.removeAll()
                self.uid.removeAll()
                for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    self.owner.append((childSnap.childSnapshot(forPath: "foodOwn").value as? String)!)
                    self.pNum.append((childSnap.childSnapshot(forPath: "phone").value as? Int)!)
                    self.uid.append((childSnap.childSnapshot(forPath: "uid").value as? String)!)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "threadMessage") {
            let vc = segue.destination as! ViewControllerNewMessage
            vc.owner = self.owner[selected!]
            vc.uid = self.uid[selected!]
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uid.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
        performSegue(withIdentifier: "threadMessage", sender: nil)
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "thread", for: indexPath)
        
        cell.textLabel?.text = owner[indexPath.row]
        
        return cell
    }

}
