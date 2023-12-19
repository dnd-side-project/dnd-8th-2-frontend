//
//  SearchResultDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/21.
//

import RxDataSources

struct SearchResultDataSource {
    var items: [Item]
}

extension SearchResultDataSource: SectionModelType {
    typealias Item = SearchPlaceKeywordListContent
    
    init(original: SearchResultDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
