//
//  CategoryDetailShoppingDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailShoppingDataSource {
    var items: [Item]
}

extension CategoryDetailShoppingDataSource: SectionModelType {
    typealias Item = CategoryDetailShoppingList
    
    init(original: CategoryDetailShoppingDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
