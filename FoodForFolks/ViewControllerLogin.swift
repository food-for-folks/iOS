//
//  ViewControllerLogin.swift
//  FoodForFolks
//
//  Created by Cory Rooker on 3/19/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewControllerLogin: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
    }
    
    
    @IBAction func btnActionLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordText.text!) { (authResult, error) in
            if(error == nil) {
                print("Signup Login\(String(describing: authResult?.user.uid))")
                UserDefaults.standard.set(true, forKey: "status")
                Switcher.updateRootVC()
            } else {
                print("Error with login \(error.debugDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //databaseCode
//                    let ref = Database.database().reference()
//                    ref.child("control").child("test").updateChildValues(["color" : "yellow", "name" : "Bob Smith"], withCompletionBlock: { (error, dbRef) in
//
//                    })
//
//                    ref.child("control").childByAutoId().setValue(["color" : "red"], withCompletionBlock: { (error, dbref) in
//
//                    })
//
}
