//
//  CategoryDetailFoodDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailFoodDataSource {
    var items: [Item]
}

extension CategoryDetailFoodDataSource: SectionModelType {
    typealias Item = CategoryDetailFoodList
    
    init(original: CategoryDetailFoodDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
