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
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
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
        let newFood = Food(itemTitle: vc.foodTitle.text!, itemQuanty: vc.foodQuanty.text!, itemPostDate: (String(Calendar.current.component(.month, from: date)) + " / " + String(Calendar.current.component(.day, from: date))), itemImage: vc.imageLoc!, idNumber: foodDatabase.count + 1, itemDescription: vc.foodDescription.text!, itemOwner: vc.nameText.text!, itemLocation: vc.foodLocation.text!, itemExpiration: (String(vc.foodExpiration.calendar.component(.month, from: date)) + " / " + String(vc.foodExpiration.calendar.component(.day, from: date))), uid: vc.uid!)
        foodDatabase.append(newFood)
        newFood.data = vc.imageToAdd.image!
        
        
        tableView.reloadData()
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
