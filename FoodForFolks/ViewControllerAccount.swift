//
//  ViewControllerAccount.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 4/4/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerAccount: UIViewController {

    @IBOutlet weak var accountName: UITextField!
    @IBOutlet weak var comapnyName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPass: UITextField!
    var name = ""
    var company = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String ?? ""
            self.company = value?["company"] as? String ?? ""
            self.comapnyName.text = self.company
            self.accountName.text = self.name
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    @IBAction func updateClicked(_ sender: Any) {
        if(self.name != self.accountName.text!) {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("name").setValue(self.accountName.text!)
        }
        
        if(self.comapnyName.text != self.company) {
            let ref = Database.database().reference().root.child("users").child(Auth.auth().currentUser!.uid)
            ref.child("company").setValue(self.comapnyName.text!)
        }
        
        if(self.newPassword.text! != "" && self.newPassword.text! == self.confirmPass.text! ) {
            let user = Auth.auth().currentUser
            let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email!)!, password: self.password.text!)
            
            user?.reauthenticate(with: credential) { error in
                if let error = error {
                    print(error)
                } else {
                    Auth.auth().currentUser?.updatePassword(to: self.confirmPass.text!) { (error) in
                        print(error!)
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    

}
