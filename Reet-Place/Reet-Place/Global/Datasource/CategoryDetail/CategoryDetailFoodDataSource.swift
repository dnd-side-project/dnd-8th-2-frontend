//
//  CategoryDetailFoodDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailFoodDataSource {
    let header: String
    var items: [Item]
}

extension CategoryDetailFoodDataSource: SectionModelType {
    typealias Item = String
    
    init(original: CategoryDetailFoodDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
