//
//  UserInfoMenuDataSource.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/16.
//

import Foundation
import RxDataSources

struct UserInfoMenuDataSource {
    var items: [Item]
}

extension UserInfoMenuDataSource: SectionModelType {
    typealias Item = UserInfoMenu
    
    init(original: UserInfoMenuDataSource, items: [Item]) {
        self = original
        self.items = items
    }
}
