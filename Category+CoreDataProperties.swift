//
//  Category+CoreDataProperties.swift
//  SpendSwift
//
//  Created by gary on 23/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category");
    }

    @NSManaged public var name: String
    @NSManaged public var categoryItems: Item?

}
