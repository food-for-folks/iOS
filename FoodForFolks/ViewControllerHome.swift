//
//  ViewControllerHome.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit

class ViewControllerHome: UIViewController {

    var testFood = TestFoodData.data
    
    var foodNumber:Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "foodDetails") {
            let foodDetails = segue.destination as! ViewControllerFoodDetails
            foodDetails.food = testFood[foodNumber!]
        }
    }
    
    @IBAction func unwindFromAdd(unwindSegue: UIStoryboardSegue) {
        let vc = unwindSegue.source as! ViewControllerNewFood
        let newFood = Food(itemTitle: vc.foodTitle.text!, itemQuanty: vc.foodQuanty.text!, itemPostDate: "111", itemImage: "111", idNumber: 2, itemDescription: vc.foodDescription.text!, itemOwner: vc.ownerName.text!, itemLocation: vc.foodLocation.text!, itemExpiration: "111")
        testFood.append(newFood)
        //print(testFood.last?.itemLocation)
        tableView.reloadData()
    }

}

extension ViewControllerHome: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellNib = UINib(nibName: "TableViewCellHome", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "HomeCell")
        return testFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! TableViewCellHome
        let food = testFood[indexPath.row]
        cell.itemDescription.text = food.itemDescription
        cell.itemQuanty.text = food.itemQuanty
        cell.postTime.text = food.itemPostDate
        cell.pictureOfFood.image = UIImage(named: "apples")!
        
        return cell
    }
}

extension ViewControllerHome: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        foodNumber = indexPath.row
        performSegue(withIdentifier: "foodDetails", sender: nil)
    }

}
