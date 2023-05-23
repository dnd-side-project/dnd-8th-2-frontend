//
//  CategoryDetailCultureDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailCultureDataSource {
    var items: [Item]
}

extension CategoryDetailCultureDataSource: SectionModelType {
    typealias Item = CategoryDetailCultureList
    
    init(original: CategoryDetailCultureDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
