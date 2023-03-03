//
//  PlaceCategoryListDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/26.
//

import RxDataSources

struct PlaceCategoryListDataSource {
    var items: [Item]
}

extension PlaceCategoryListDataSource: SectionModelType {
    typealias Item = PlaceCategoryList
    
    init(original: PlaceCategoryListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
