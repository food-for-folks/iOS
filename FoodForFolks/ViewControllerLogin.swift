//
//  ViewControllerLogin.swift
//  FoodForFolks
//
//  Created by Cory Rooker on 3/19/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit

class ViewControllerLogin: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnActionLogin(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "status")
        Switcher.updateRootVC()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
