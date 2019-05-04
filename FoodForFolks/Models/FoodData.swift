//
//  FoodData.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//

import Foundation
import UIKit

class Food {
    
    var itemTitle:String?
    var itemQuanty:String?
    var itemPostDate:String?
    var itemImage:String?
    var idNumber:Int?
    var itemDescription:String?
    var itemOwner:String?
    var itemLocation:String?
    var itemExpiration:String?
    var uid:String?
    var data:UIImage?
    var postUID:String?
    var pNum:Int?
    
    init(itemTitle:String, itemQuanty:String, itemPostDate:String, itemImage:String, idNumber:Int, itemDescription:String, itemOwner:String, itemLocation:String, itemExpiration:String, uid:String) {
        self.itemTitle = itemTitle
        self.itemQuanty = itemQuanty
        self.itemPostDate = itemPostDate
        self.itemImage = itemImage
        self.idNumber = idNumber
        self.itemDescription = itemDescription
        self.itemOwner = itemOwner
        self.itemLocation = itemLocation
        self.itemExpiration = itemExpiration
        self.uid = uid
    }
}

//class TestFoodData {
//    static let data = [Food(itemTitle:"Some Food", itemQuanty:"A lot of food", itemPostDate:"March 03, 2018", itemImage:"Test Data", idNumber:0, itemDescription:"The is really good food", itemOwner:"Cory Rooker", itemLocation:"136 Knotts Ln. Roanoke Rapids, NC 27870", itemExpiration:"March 15th")]
//}
