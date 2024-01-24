//
//  Array+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/12/03.
//

import UIKit

extension Array where Element: Comparable {
    
    /// 두 배열 내부의 요소를 비교하여 동일여부 판단
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
    
}
