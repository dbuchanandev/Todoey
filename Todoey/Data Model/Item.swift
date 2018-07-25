//
//  Item.swift
//  Todoey
//
//  Created by Donavon on 7/22/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
