//
//  SearchHistory+CoreDataProperties.swift
//  
//
//  Created by Kennadi on 2/7/24.
//
//

import Foundation
import CoreData


extension SearchHistory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchHistory> {
        return NSFetchRequest<SearchHistory>(entityName: CoreDataEntityList.searchHistory.name)
    }

    @NSManaged public var keyword: String?
    @NSManaged public var time: Date?

}
