//
//  CategoryFilter+CoreDataProperties.swift
//  
//
//  Created by Kim HeeJae on 2023/10/28.
//
//

import Foundation
import CoreData


extension CategoryFilter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryFilter> {
        return NSFetchRequest<CategoryFilter>(entityName: "CategoryFilter")
    }

    @NSManaged public var category: String?
    @NSManaged public var subCategory: [String]?

}
