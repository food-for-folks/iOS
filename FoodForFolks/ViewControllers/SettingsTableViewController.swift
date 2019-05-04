//
//  SettingsTableViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    
    
    @IBAction func logout(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            if(Auth.auth().currentUser == nil) {
                UserDefaults.standard.set(false, forKey: "status")
                Switcher.updateRootVC()
            }
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row == 0) {
            performSegue(withIdentifier: "account", sender: nil)
        }
        
        if(indexPath.row == 1) {
            performSegue(withIdentifier: "notify", sender: nil)
        }
        
        if(indexPath.row == 2) {
            performSegue(withIdentifier: "location", sender: nil)
        }
        
        if(indexPath.row == 3) {
            performSegue(withIdentifier: "faq", sender: nil)
        }
        
        if(indexPath.row == 4) {
            performSegue(withIdentifier: "privacy", sender: nil)
        }
        
    }
    
}
