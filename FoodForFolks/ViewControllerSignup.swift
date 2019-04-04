//
//  ViewControllerSignup.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 4/2/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ViewControllerSignup: UIViewController {

    
    let alertPassword = UIAlertController(title: "Error!", message: "Missing Password or do not match!", preferredStyle: .alert)
    
    let alertEmail = UIAlertController(title: "Error!", message: "Missing Email", preferredStyle: .alert)
    
    
    func addOkButton() {
        alertPassword.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertEmail.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addOkButton();
        
    }
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    
    
    @IBAction func submitClick(_ sender: Any) {
        
        if(emailText.text == "") {
            self.present(alertEmail, animated: true, completion: nil)
        } else if(passwordText.text == "" || passwordText.text != confirmPassText.text) {
            self.present(alertPassword, animated: true, completion: nil)
        } else if(emailText.text != "" && passwordText.text != "") {
        
            if(Auth.auth().currentUser == nil) {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authResult, error) in
                    if(error == nil) {
                        print("Signup Succesful")
                        UserDefaults.standard.set(true, forKey: "status")
                        Switcher.updateRootVC()
                    } else {
                        
                        let alert = UIAlertController(title: "Error!", message: "Error with login \(error.debugDescription)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                            NSLog("The \"OK\" alert occured.")
                        }))
                        self.present(alert, animated: true, completion: nil)
                        print("Signup error \(error.debugDescription)")
                    }
                }
            }
        }

    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
}
