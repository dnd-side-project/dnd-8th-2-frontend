//
//  CategoryDetailActivityDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailActivityDataSource {
    var items: [Item]
}

extension CategoryDetailActivityDataSource: SectionModelType {
    typealias Item = CategoryDetailActivityList
    
    init(original: CategoryDetailActivityDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
