//
//  ViewControllerMessages.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerClaimed: UIViewController {

    
    var foodDatabase = [Food]()
    var done:Bool?
    var foodNumber:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        getData()
        tableView.allowsSelection = true
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    func getData() {
        let ref = Database.database().reference()
        tableView.delegate = self
        
        ref.child("users").child(Auth.auth().currentUser!.uid).child("food").observe(.value) { (snapshot) in
            if(snapshot.value != nil) {
                var titleFood = ""
                var quantity = ""
                var itemDes = ""
                var owner  = ""
                var location = ""
                var exp = ""
                var uid = ""
                var pNum = 0
                for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    titleFood = (childSnap.childSnapshot(forPath: "foodTitle").value as? String)!
                    quantity = (childSnap.childSnapshot(forPath: "foodQuanty").value as? String)!
                    itemDes = (childSnap.childSnapshot(forPath: "foodDes").value as? String)!
                    owner = (childSnap.childSnapshot(forPath: "foodOwn").value as? String)!
                    location = (childSnap.childSnapshot(forPath: "foodLocation").value as? String)!
                    exp = (childSnap.childSnapshot(forPath: "foodExp").value as? String)!
                    pNum = (childSnap.childSnapshot(forPath: "phone").value as? Int)!
                    uid = (childSnap.childSnapshot(forPath: "uid").value as? String)!
                    
                    let newFood = Food(itemTitle: titleFood, itemQuanty: quantity, itemPostDate: "", itemImage: "", idNumber: 0, itemDescription: itemDes, itemOwner: owner, itemLocation: location, itemExpiration: exp, uid: uid)
                    newFood.pNum = pNum
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let imageRef = storageRef.child("/images/\(titleFood)")
                    imageRef.getData(maxSize: 10 * 1024 * 1024, completion: { (data, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            let image = UIImage(data: data!)
                            newFood.data = image
                            self.foodDatabase.append(newFood)
                            self.done = true
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ClaimedDetails") {
            let foodDetails = segue.destination as! ViewControllerFoodDetails
            foodDetails.food = foodDatabase[foodNumber!]
            foodDetails.claimed = true
        }
    }

}


extension ViewControllerClaimed: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodDatabase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "claimedCell", for: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
        let title = cell.viewWithTag(200) as! UILabel
        let company = cell.viewWithTag(300) as! UILabel
        let phoneNumber = cell.viewWithTag(400) as! UILabel
        
        
        let ref = Database.database().reference()
        ref.child("users").child(foodDatabase[indexPath.row].uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let companyData = value?["company"] as? String ?? ""
            company.text = companyData
        }) { (error) in
            print(error.localizedDescription)
        }
        
        imageView.image = foodDatabase[indexPath.row].data
        title.text = foodDatabase[indexPath.row].itemTitle
        phoneNumber.text = "\(foodDatabase[indexPath.row].pNum!)"
        
        return cell
    }
}

extension ViewControllerClaimed: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodNumber = indexPath.row
        performSegue(withIdentifier: "ClaimedDetails", sender: nil)
    }
    
}
