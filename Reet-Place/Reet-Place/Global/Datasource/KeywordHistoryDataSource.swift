//
//  KeywordHistoryDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/06/20.
//

import RxDataSources

struct KeywordHistoryDataSource {
    var items: [Item]
}

extension KeywordHistoryDataSource: SectionModelType {
    typealias Item = SearchHistoryContent
    
    init(original: KeywordHistoryDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
