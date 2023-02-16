//
//  MyPageMenuDataSource.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import Foundation
import RxDataSources

struct MyPageMenuDataSource {
    var items: [Item]
}

extension MyPageMenuDataSource: SectionModelType {
    typealias Item = MyPageMenu
    
    init(original: MyPageMenuDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
