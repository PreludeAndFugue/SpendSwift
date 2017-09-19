//
//  Item+CoreDataProperties.swift
//  SpendSwift
//
//  Created by gary on 23/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var name: String
    @NSManaged public var cost: Int32
    @NSManaged public var purchaseDate: NSDate
    @NSManaged public var itemCategory: Category

}
