//
//  ViewControllerHome.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import Firebase

class ViewControllerHome: UIViewController {

    var foodDatabase = [Food]()
    
    var foodNumber:Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    var user:UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()

    }

    func getData() {
        let ref = Database.database().reference()
        ref.child("food").observe(.value) { (snapshot) in
            if(snapshot.value != nil) {
                var titleFood = ""
                var quantity = ""
                var postDate = ""
                var itemImage = ""
                var idNumber = 0
                var itemDes = ""
                var owner  = ""
                var location = ""
                var exp = ""
                var uid = ""
                self.foodDatabase.removeAll()
                for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    titleFood = (childSnap.childSnapshot(forPath: "title").value as? String)!
                    quantity = (childSnap.childSnapshot(forPath: "quantity").value as? String)!
                    postDate = (childSnap.childSnapshot(forPath: "postDate").value as? String)!
                    itemImage = (childSnap.childSnapshot(forPath: "image").value as? String)!
                    idNumber = (childSnap.childSnapshot(forPath: "idNumber").value as? Int)!
                    itemDes = (childSnap.childSnapshot(forPath: "description").value as? String)!
                    owner = (childSnap.childSnapshot(forPath: "owner").value as? String)!
                    location = (childSnap.childSnapshot(forPath: "location").value as? String)!
                    exp = (childSnap.childSnapshot(forPath: "expiration").value as? String)!
                    uid = childSnap.key
                    
                    let newFood = Food(itemTitle: titleFood, itemQuanty: quantity, itemPostDate: postDate, itemImage: itemImage, idNumber: idNumber, itemDescription: itemDes, itemOwner: owner, itemLocation: location, itemExpiration: exp, uid: uid)
                    
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let imageRef = storageRef.child((Auth.auth().currentUser?.email)! + "/images/\(titleFood)")
                    imageRef.getData(maxSize: 8 * 1024 * 1024, completion: { (data, error) in
                        if error != nil {
                            print(error!)
                        } else {
                            let image = UIImage(data: data!)
                            newFood.data = image
                            self.foodDatabase.append(newFood)
                            self.tableView.reloadData()
                        }
                    })
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "foodDetails") {
            let foodDetails = segue.destination as! ViewControllerFoodDetails
            foodDetails.food = foodDatabase[foodNumber!]
        }
    }
    
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! ViewControllerNewFood
        let date = Date()
        
        let ref = Database.database().reference()
        ref.child("food").childByAutoId().updateChildValues(["title": vc.foodTitle.text!, "postDate": (String(Calendar.current.component(.month, from: date)) + " / " + String(Calendar.current.component(.day, from: date))), "image": vc.imageLoc, "idNumber": foodDatabase.count + 1, "description": vc.foodDescription.text, "owner": vc.nameText.text, "location": vc.foodLocation.text, "expiration": vc.foodExpiration.date.description, "uid": vc.uid, "quantity": vc.foodQuanty.text])
    }
}

extension ViewControllerHome: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNib = UINib(nibName: "TableViewCellHome", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HomeCell")
        return foodDatabase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! TableViewCellHome
        let food = foodDatabase[indexPath.row]
        cell.itemDescription.text = food.itemDescription
        cell.itemQuanty.text = food.itemQuanty
        cell.postTime.text = food.itemPostDate
        cell.pictureOfFood.image = food.data
        
        return cell
    }
}

extension ViewControllerHome: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodNumber = indexPath.row
        performSegue(withIdentifier: "foodDetails", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
    }

}
