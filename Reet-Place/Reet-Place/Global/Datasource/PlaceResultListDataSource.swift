//
//  PlaceResultListDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/19.
//

import RxDataSources

struct PlaceResultListDataSource {
    var items: [Item]
}

extension PlaceResultListDataSource: SectionModelType {
    typealias Item = SearchPlaceListContent
    
    init(original: PlaceResultListDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
