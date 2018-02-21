//
//  Category.swift
//  Todoey
//
//  Created by Vice Priborkin on 21/02/2018.
//  Copyright © 2018 Vice Priborkin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    //Each Category points to a list of items
    //List comes from Realm - not Swift!
    let items : List<Item> = List<Item>()
}
