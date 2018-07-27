//
//  Category.swift
//  Todoey
//
//  Created by Donavon on 7/22/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var hexColor : String = ""
    let items = List<Item>()
}
