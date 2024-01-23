//
//  CategoryDetailListDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/16.
//

import RxDataSources

struct CategoryDetailListDataSource {
    var items: [Item]
}

extension CategoryDetailListDataSource: SectionModelType {
    typealias Item = TabPlaceCategoryList
    
    init(original: CategoryDetailListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
