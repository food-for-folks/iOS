//
//  ViewControllerNewFood.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit

class ViewControllerNewFood: UIViewController {

    
    @IBOutlet weak var imageToAdd: UIImageView!
    @IBOutlet weak var foodTitle: UITextField!
    @IBOutlet weak var foodDescription: UITextField!
    @IBOutlet weak var foodExpiration: UIDatePicker!
    @IBOutlet weak var foodQuanty: UITextField!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var foodLocation: UITextField!
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) 
    }
    
    @IBAction func checkSubmit(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
