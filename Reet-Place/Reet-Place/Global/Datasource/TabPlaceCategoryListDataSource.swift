//
//  TabPlaceCategoryListDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/03.
//

import RxDataSources

struct TabPlaceCategoryListDataSource {
    var items: [Item]
}

extension TabPlaceCategoryListDataSource: SectionModelType {
    typealias Item = TabPlaceCategoryList
    
    init(original: TabPlaceCategoryListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
