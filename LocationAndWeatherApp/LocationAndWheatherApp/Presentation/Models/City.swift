//
//  City.swift
//  LocationAndWheatherApp
//
//  Created by Михаил Серёгин on 24.09.2021.
//

import Foundation
import RealmSwift

class City: Object {
    
    
    @objc dynamic var name: String = ""
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
}

