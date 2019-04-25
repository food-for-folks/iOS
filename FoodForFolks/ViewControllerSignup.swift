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
    
    let alertName = UIAlertController(title: "Error!", message: "Name cannot be blank!", preferredStyle: .alert)
    
    let alertCity = UIAlertController(title: "Error!", message: "City cannot be blank!", preferredStyle: .alert)
    
    let alertCompany = UIAlertController(title: "Error!", message: "Company cannot be blank!", preferredStyle: .alert)
    
    let alertAddress = UIAlertController(title: "Error!", message: "Address cannot be blank!", preferredStyle: .alert)
    
    let alertState = UIAlertController(title: "Error!", message: "State cannot be blank!", preferredStyle: .alert)
    
    let alertZip = UIAlertController(title: "Error!", message: "Zip cannot be blank!", preferredStyle: .alert)
    
    
    func addOkButton() {
        alertPassword.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertEmail.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertName.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertCity.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertCompany.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertAddress.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertState.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
        alertZip.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addOkButton();
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        
    }
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var cNameText: UITextField!
    @IBOutlet weak var addressLineOneText: UITextField!
    @IBOutlet weak var addressLineTwoText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    @IBOutlet weak var zipCodeText: UITextField!
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBAction func submitClick(_ sender: Any) {
        
        if(emailText.text == "") {
            self.present(alertEmail, animated: true, completion: nil)
        } else if(passwordText.text == "" || passwordText.text != confirmPassText.text) {
            self.present(alertPassword, animated: true, completion: nil)
        } else if(nameText.text == "") {
            self.present(alertName, animated: true, completion: nil)
        } else if(cityText.text == "") {
            self.present(alertCity, animated: true, completion: nil)
        } else if(cNameText.text == "") {
            self.present(alertCompany, animated: true, completion: nil)
        } else if(addressLineOneText.text == "") {
            self.present(alertAddress, animated: true, completion: nil)
        } else if(stateText.text == "") {
            self.present(alertState, animated: true, completion: nil)
        } else if(zipCodeText.text == "") {
            self.present(alertZip, animated: true, completion: nil)
        } else if(emailText.text != "" && passwordText.text != "") {
        
            if(Auth.auth().currentUser == nil) {
                Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authResult, error) in
                    if(error == nil) {
                        print("Signup Succesful")
                        
                        let ref = Database.database().reference()
                        ref.child("users").child("\(Auth.auth().currentUser!.uid)").updateChildValues(["email": self.emailText.text!, "name": self.nameText.text!, "city": self.cityText.text, "company": self.cNameText.text!, "address1": self.addressLineOneText.text!, "address2": self.addressLineTwoText.text ?? "", "state": self.stateText.text, "zip": self.zipCodeText.text, "donorRec": self.selector.selectedSegmentIndex, "uid": Auth.auth().currentUser!.uid])
                        
                        
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
