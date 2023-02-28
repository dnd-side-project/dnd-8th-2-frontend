//
//  CaseIterable+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/25.
//

import UIKit

extension CaseIterable {
}

extension CaseIterable where Self: Equatable {
    /// Return index by order of declared CaseIterable Enum types
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex { self == $0 }
    }
}
