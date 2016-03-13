//
//  image.swift
//  Chronicle
//
//  Created by Johan Sveningsson on 2016-03-12.
//  Copyright © 2016 Dobus. All rights reserved.
//

import Foundation

import RealmSwift

class User: Object {
    dynamic var userId: String = ""
    dynamic var image: String = ""
    
    override static func primaryKey() -> String {
        return "userId"
    }
}