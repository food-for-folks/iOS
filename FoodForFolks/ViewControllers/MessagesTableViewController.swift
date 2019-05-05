//
//  MessagesTableViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 5/3/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase

class MessagesTableViewController: UITableViewController {
    
    var threads = [String]()
    var owner  = [String]()
    var uid = [String]()
    var pNum = [Int]()
    var selected:Int?
    var company = [String]()
    var foodName = [String]()
    
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
                    self.company.append((childSnap.childSnapshot(forPath: "company").value as? String)!)
                    self.foodName.append((childSnap.childSnapshot(forPath: "foodTitle").value as? String)!)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "threadMessage") {
            let vc = segue.destination as! NewMessageViewController
            vc.owner = self.owner[selected!]
            vc.UID = self.uid[selected!]
            vc.comp = self.company[selected!]
            vc.foodName = self.foodName[selected!]
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
        
        cell.textLabel?.text = company[indexPath.row]
        cell.detailTextLabel?.text = foodName[indexPath.row]
        
        return cell
    }
    
}
