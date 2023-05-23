//
//  CategoryDetailPhotoBoothDataSource.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/15.
//

import RxDataSources

struct CategoryDetailPhotoBoothDataSource {
    var items: [Item]
}

extension CategoryDetailPhotoBoothDataSource: SectionModelType {
    typealias Item = CategoryDetailPhotoBoothList
    
    init(original: CategoryDetailPhotoBoothDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
