//
//  SearchHistoryListDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/22.
//

import RxDataSources

struct SearchHistoryListDataSource {
    var items: [Item]
}

extension SearchHistoryListDataSource: SectionModelType {
    typealias Item = TabPlaceCategoryList
    
    init(original: SearchHistoryListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
