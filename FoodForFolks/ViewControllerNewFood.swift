//
//  ViewControllerNewFood.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerNewFood: UITableViewController {

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
        let localFile = imageToAdd.image?.jpegData(compressionQuality: 10)
        
        _ = imageRef.putData(localFile!, metadata: nil) { metadata, error in
            guard metadata != nil else {
                return
            }
        }
        self.dismiss(animated: true) {
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
        var name = "test"
        var address = "test"
        var city = "test"
        var address2 = "test"
        var state = "test"
        var zip = "test"
        ref.child("users").observe(.value) { (snapshot) in
            if(snapshot.value != nil) {
                for child in snapshot.children {
                     let childSnap = child as! DataSnapshot
                     name = childSnap.childSnapshot(forPath: "name").value as! String
                     address = childSnap.childSnapshot(forPath: "address1").value as! String
                     address2 = childSnap.childSnapshot(forPath: "address2").value as! String
                    city = childSnap.childSnapshot(forPath: "city").value as! String
                    state = childSnap.childSnapshot(forPath: "state").value as! String
                    zip = childSnap.childSnapshot(forPath: "zip").value as! String
                }
                self.nameText.text = name
                self.foodLocation.text = "\(address) \(address2) \(city), \(state) \(zip)"
            }
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // For removing the extra empty spaces of TableView below
        tableView.tableFooterView = UIView()
    }
    
}
