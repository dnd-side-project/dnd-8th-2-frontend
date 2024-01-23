//
//  CategoryDetailDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/10/18.
//

import RxDataSources

struct CategoryDetailDataSource {
    let header: String
    var items: [Item]
    var parameterCategory: [String]
}

extension CategoryDetailDataSource: SectionModelType {
    typealias Item = String
    
    init(original: CategoryDetailDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
