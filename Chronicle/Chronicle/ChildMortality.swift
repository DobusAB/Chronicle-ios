//
//  childMortality.swift
//  Chronicle
//
//  Created by Sebastian Marcusson on 2016-03-13.
//  Copyright © 2016 Dobus. All rights reserved.
//

import Foundation
import RealmSwift

class ChildMortality: Object {
    dynamic var year: String = ""
    dynamic var deathCount: String = ""
    
    override static func primaryKey() -> String {
        return "year"
    }
}