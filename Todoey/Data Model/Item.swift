//
//  TodoItem.swift
//  Todoey
//
//  Created by Donavon on 7/17/18.
//  Copyright © 2018 Donavon Buchanan. All rights reserved.
//

import Foundation

class Item {
    var title: String
    var done: Bool = false
    
    init(title: String) {
        self.title = title
    }
    
    convenience init() {
        self.init(title: "New Item")
    }
    
}
