//
//  TableViewControllerSettings.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import FirebaseAuth

class TableViewControllerSettings: UITableViewController {

    
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
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
