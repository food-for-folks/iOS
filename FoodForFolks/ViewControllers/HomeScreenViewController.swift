//
//  HomeScreenViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class HomeScreenViewController: UIViewController {
    // Local database to hold posted items downloaded from firebase
    var foodDatabase = [Food]()
    
    // Number of the row selected
    var foodNumber:Int?
    
    // data has been downloaded and does not need to be refreashed
    var done = false
    
    // Database to hold items that have been searched for
    var searchQuery = [Food]()
    
    // Still searching
    var searching = false
    
    // Hold user data for the item owner
    var user:UserData?
    
    // Connection to tableView
    @IBOutlet weak var tableView: UITableView!
    
    // Connection to the searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Connection to the addButton
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Bundle.main.bundleURL)
        //print(tabBarController?.viewControllers)
        
        // connect search bar
        searchBar.delegate = self
        
        // setup firebase database
        let ref = Database.database().reference()
        
        // get location of data
        ref.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            // load the data stored in the database
            let value = snapshot.value as? NSDictionary
            
            // get the donor type of the logged in user
            let userType = value?["donorRec"] as? Int ?? 0
            
            // hide or show the add button based on type of user
            if(userType == 0) {
                self.addButton.isEnabled = false
            } else if(userType == 1) {
                self.addButton.isEnabled = true
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        HUD.show(.progress)
        if(!self.done) {
            self.getData()
        }
        // Now some long running task starts...
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // ...and once it finishes we flash the HUD for a second.
            HUD.flash(.success, delay: 1.0)
        }
    }
    
    
    @IBAction func filterButtonClicked(_ sender: Any) {
        let action: UIAlertController = UIAlertController(title: "Sort By", message: "Pick option to sort the food by", preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        let nameActionButton = UIAlertAction(title: "Name (A-Z)", style: .default) { _ in
            print("name")
            let nameArray = self.foodDatabase.sorted {
                //$0.itemTitle! < $1.itemTitle!
                $0.itemTitle!.localizedStandardCompare($1.itemTitle!) == .orderedAscending
            }
            self.foodDatabase = nameArray
            self.tableView.reloadData()
        }
        let ageActionButton = UIAlertAction(title: "Expiration", style: .default) { _ in
            print("expiration")
            let nameArray = self.foodDatabase.sorted {
                $0.itemExpiration! < $1.itemExpiration!
            }
            self.foodDatabase = nameArray
            self.tableView.reloadData()
        }
        let stateActionButton = UIAlertAction(title: "Quantity (Small to Large)", style: .default) { _ in
            print("quantity")
            let nameArray = self.foodDatabase.sorted {
                $0.itemQuanty!.localizedStandardCompare($1.itemQuanty!) == .orderedAscending
            }
            self.foodDatabase = nameArray
            self.tableView.reloadData()
        }
        action.addAction(cancelActionButton)
        action.addAction(nameActionButton)
        action.addAction(ageActionButton)
        action.addAction(stateActionButton)
        self.present(action, animated: true, completion: nil)
    }
    
    
    func getData() {
        let ref = Database.database().reference()
        tableView.delegate = self
        
        ref.child("food").observe(.value) { (snapshot) in
            self.foodDatabase.removeAll()
            self.tableView.reloadData()
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
                var postUID = ""
                var pNum = 0
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
                    pNum = (childSnap.childSnapshot(forPath: "phone").value as? Int)!
                    uid = childSnap.key
                    postUID = (childSnap.childSnapshot(forPath: "uid").value as? String)!
                    
                    let newFood = Food(itemTitle: titleFood, itemQuanty: quantity, itemPostDate: postDate, itemImage: itemImage, idNumber: idNumber, itemDescription: itemDes, itemOwner: owner, itemLocation: location, itemExpiration: exp, uid: uid)
                    newFood.postUID = postUID
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
                            let vc = self.tabBarController!.viewControllers![1] as? MapsViewController
                            vc?.foodDatabase = self.foodDatabase
                        }
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "foodDetails") {
            let foodDetails = segue.destination as! FoodDetailsViewController
            foodDetails.food = foodDatabase[foodNumber!]
        }
    }
    
    @IBAction func unwindFromDetails(unwindSegue: UIStoryboardSegue) {
        let ref = Database.database().reference()
        ref.child("food").child(foodDatabase[foodNumber!].uid!).removeValue()
        foodDatabase.remove(at: foodNumber!)
        tableView.reloadData()
    }
    
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! AddFoodViewController
        let date = Date()
        HUD.show(.progress)
        
        // Now some long running task starts...
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // ...and once it finishes we flash the HUD for a second.
            HUD.flash(.success, delay: 1.0)
            let ref2 = Database.database().reference()
            ref2.child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let phone = value?["phone"] as? Int64 ?? 0
                let ref = Database.database().reference()
                ref.child("food").childByAutoId().updateChildValues(["title": vc.foodTitle.text!, "postDate": (String(Calendar.current.component(.month, from: date)) + " / " + String(Calendar.current.component(.day, from: date))), "image": vc.imageLoc!, "idNumber": self.foodDatabase.count + 1, "description": vc.foodDescription.text!, "owner": vc.nameText.text!, "location": vc.foodLocation.text!, "expiration": vc.foodExpiration.date.description, "uid": vc.uid!, "quantity": vc.foodQuanty.text!, "postUID": Auth.auth().currentUser!.uid, "phone": phone])
                self.done = false
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
}

extension HomeScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNib = UINib(nibName: "TableViewCellHome", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HomeCell")
        if searching {
            return searchQuery.count
        }else {
            return foodDatabase.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        if searching {
            cell.itemDescription.text = searchQuery[indexPath.row].itemTitle
            cell.itemQuanty.text = searchQuery[indexPath.row].itemQuanty
            cell.postTime.text = searchQuery[indexPath.row].itemPostDate
            cell.pictureOfFood.image = searchQuery[indexPath.row].data
        } else if(done) {
            cell.itemDescription.text = foodDatabase[indexPath.row].itemTitle
            cell.itemQuanty.text = foodDatabase[indexPath.row].itemQuanty
            cell.postTime.text = foodDatabase[indexPath.row].itemPostDate
            cell.pictureOfFood.image = foodDatabase[indexPath.row].data
        }
        
        
        return cell
    }
}

extension HomeScreenViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        foodNumber = indexPath.row
        performSegue(withIdentifier: "foodDetails", sender: nil)
    }
    
}

extension HomeScreenViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        searchQuery = foodDatabase.filter({$0.itemTitle!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        tableView.reloadData()
        
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searching = false
        view.endEditing(true)
        tableView.reloadData()
    }
}
