//
//  Checklist.swift
//  CheckList
//
//  Created by Ricardo Roman Landeros on 09/04/22.
//

import UIKit

class Checklist: NSObject, Codable {

    var name = ""
    var iconName = "No Icon"
    var items = [ChecklistItem]()
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func countUncheckedItems() -> Int {
        var count  = 0
        for item in items where !item.checkedn {
            count += 1
        }
        return count
    }
}
