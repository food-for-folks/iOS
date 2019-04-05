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
    
    
    var imageLoc:String?
    var uid = Auth.auth().currentUser?.uid
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) 
    }
    
    @IBAction func checkSubmit(_ sender: Any) {
        
        let storageRef = storage.reference()
        let imageRef = storageRef.child((Auth.auth().currentUser?.email)! + "/images/\(foodTitle.text)")
        imageLoc = (Auth.auth().currentUser?.email)! + "/images/\(foodTitle.text)"
        let localFile = imageToAdd.image?.jpegData(compressionQuality: 10)
        
        _ = imageRef.putData(localFile!, metadata: nil) { metadata, error in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
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
        ref.child("users").observe(.value) { (snapshot) in
            if(snapshot.value != nil) {
                for child in snapshot.children {
                     let childSnap = child as! DataSnapshot
                     name = childSnap.childSnapshot(forPath: "name").value as! String
                     self.nameText.text = name
                }
            }
        }
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // For removing the extra empty spaces of TableView below
        tableView.tableFooterView = UIView()
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 4 {
//            if dateCellExpanded {
//                dateCellExpanded = false
//            } else {
//                dateCellExpanded = true
//            }
//            tableView.beginUpdates()
//            tableView.endUpdates()
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 4 {
//            if dateCellExpanded {
//                return 250
//            } else {
//                return 50
//            }
//        }
//        return 50
//    }
}
