//
//  ViewControllerAccount.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 4/4/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerAccount: UIViewController {

    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var comapnyName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    var name = ""
    var company = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("users").observe(.value) { (snapshot) in
            for child in snapshot.children {
                let childSnap = child as! DataSnapshot
                self.name = (childSnap.childSnapshot(forPath: "name").value as? String)!
                self.company = (childSnap.childSnapshot(forPath: "company").value as? String)!
            }
            self.accountName.text = self.name
            self.comapnyName.text = self.company
            
        }
        
    }
    @IBAction func updateClicked(_ sender: Any) {
        if(self.name != self.accountName.text!) {
            
        }
    }
    

}
