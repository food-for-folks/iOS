//
//  CoordinateData.swift
//  FoodForFolks
//
//  Created by tobarows on 4/29/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import Foundation
import CoreLocation

class CoordinateData {
    var point: CLLocationCoordinate2D
    var address: String?
    var count: Int
    
    
    init(point: CLLocationCoordinate2D, address: String?, count: Int) {
        self.address = address
        self.count = count
        self.point = point
    }
}
