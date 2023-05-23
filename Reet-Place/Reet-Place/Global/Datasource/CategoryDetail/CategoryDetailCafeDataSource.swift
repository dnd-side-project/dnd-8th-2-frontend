//
//  CategoryDetailCafeDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailCafeDataSource {
    var items: [Item]
}

extension CategoryDetailCafeDataSource: SectionModelType {
    typealias Item = CategoryDetailCafeList
    
    init(original: CategoryDetailCafeDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
