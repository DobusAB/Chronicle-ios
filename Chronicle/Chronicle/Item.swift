//
//  Item.swift
//  Chronicle
//
//  Created by Sebastian Marcusson on 2016-02-27.
//  Copyright © 2016 Dobus. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    dynamic var itemId: String = ""
    dynamic var serviceOrganization: String = ""
    dynamic var itemLabel: String = ""
    dynamic var thumbnail: String = ""
    dynamic var itemType: String = ""
    dynamic var itemDescription: String = ""
    dynamic var lat: Double = 0.0
    dynamic var lng: Double = 0.0
    dynamic var haversine: Double = 0.0
    dynamic var discovered: Bool = false
    dynamic var timeLabel: String = ""
    
    //dynamic var itemDescription: String = ""

    override static func primaryKey() -> String {
        return "itemId"
    }
}