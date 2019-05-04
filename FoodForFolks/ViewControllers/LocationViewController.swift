//
//  LocationViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 4/4/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase

class LocationViewController: UIViewController {
    
    
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var cityLine: UITextField!
    @IBOutlet weak var stateLine: UITextField!
    @IBOutlet weak var zipCodeLine: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let address = value?["address1"] as? String ?? ""
            let city = value?["city"] as? String ?? ""
            let address2 = value?["address2"] as? String ?? ""
            let state = value?["state"] as? String ?? ""
            let zip = value?["zip"] as? String ?? ""
            self.addressLine1.text = address
            self.addressLine2.text = address2
            self.cityLine.text = city
            self.stateLine.text = state
            self.zipCodeLine.text = zip
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func updateButtonClicked(_ sender: Any) {
        if(self.addressLine1.text != "") {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("address1").setValue(self.addressLine1.text!)
        }
        
        if(self.addressLine2.text != "") {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("address2").setValue(self.addressLine2.text!)
        }
        
        if(self.cityLine.text != "") {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("city").setValue(self.cityLine.text!)
        }
        
        if(self.stateLine.text != "") {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("state").setValue(self.stateLine.text!)
        }
        
        if(self.zipCodeLine.text != "") {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("zip").setValue(self.zipCodeLine.text!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
