//
//  ViewControllerFoodDetails.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit

class ViewControllerFoodDetails: UIViewController {

    var food:Food?
    
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodTitle: UILabel!
    @IBOutlet weak var foodQuanty: UILabel!
    @IBOutlet weak var foodExpiration: UILabel!
    @IBOutlet weak var foodDescription: UILabel!
    @IBOutlet weak var foodOwner: UILabel!
    @IBOutlet weak var foodLocation: UILabel!
    
    @IBAction func doneButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodImage.image = UIImage(named: "apples")!
        foodTitle.text = food?.itemTitle
        foodQuanty.text = food?.itemQuanty
        foodExpiration.text = food?.itemExpiration
        foodDescription.text = food?.itemDescription
        foodOwner.text = food?.itemOwner
        foodLocation.text = food?.itemLocation
        // Do any additional setup after loading the view.
    }

}
