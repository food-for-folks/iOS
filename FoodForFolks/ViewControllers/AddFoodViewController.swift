//
//  AddFoodViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase

class AddFoodViewController: UITableViewController {
    
    let storage = Storage.storage()
    @IBOutlet weak var imageToAdd: UIImageView!
    @IBOutlet weak var foodTitle: UITextField!
    @IBOutlet weak var foodDescription: UITextField!
    @IBOutlet weak var foodExpiration: UIDatePicker!
    @IBOutlet weak var foodQuanty: UITextField!
    @IBOutlet weak var foodLocation: UITextField!
    @IBOutlet weak var nameText: UITextField!
    var food:Food?
    
    var imageLoc:String?
    var uid = Auth.auth().currentUser?.uid
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) 
    }
    
    @IBAction func checkSubmit(_ sender: Any) {
        let storageRef = storage.reference()
        let imageRef = storageRef.child("/images/\(foodTitle.text!)")
        imageLoc = "/images/\(foodTitle.text!)"
        let localFile = imageToAdd.image?.jpegData(compressionQuality: 90)
        
        _ = imageRef.putData(localFile!, metadata: nil) { metadata, error in
            guard metadata != nil else {
                return
            }
            
            self.dismiss(animated: true) {
            }
        }
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        ImagePickerManager().pickImage(self){ image in
            self.imageToAdd.image = image
        }
    }
    
    private var dateCellExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let name = value?["name"] as? String ?? ""
            let address = value?["address1"] as? String ?? ""
            let city = value?["city"] as? String ?? ""
            let address2 = value?["address2"] as? String ?? ""
            let state = value?["state"] as? String ?? ""
            let zip = value?["zip"] as? String ?? ""
            self.nameText.text = name
            self.foodLocation.text = "\(address) \(address2) \(city), \(state) \(zip)"
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // For removing the extra empty spaces of TableView below
        tableView.tableFooterView = UIView()
    }
    
}
