//
//  ViewControllerLogin.swift
//  FoodForFolks
//
//  Created by Cory Rooker on 3/19/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        addOkButton()
    }
    
    let alertPassword = UIAlertController(title: "Error!", message: "Missing Password!", preferredStyle: .alert)
    
    let alertEmail = UIAlertController(title: "Error!", message: "Missing Email", preferredStyle: .alert)
    
    
    func addOkButton() {
        alertPassword.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertEmail.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
    }
    
    
    @IBAction func btnActionLogin(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailLabel.text!, password: passwordText.text!) { (authResult, error) in
            if(error == nil) {
                print("Signup Login\(String(describing: authResult?.user.uid))")
                UserDefaults.standard.set(true, forKey: "status")
                Switcher.updateRootVC()
            } else {
                let alert = UIAlertController(title: "Error!", message: "Error with login \(error.debugDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
