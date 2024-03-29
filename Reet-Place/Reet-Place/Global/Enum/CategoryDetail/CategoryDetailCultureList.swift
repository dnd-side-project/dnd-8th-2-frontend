//
//  CategoryDetailCultureList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

/// 문화생활
enum CategoryDetailCultureList: String {
    case theater = "영화관"
    case driveInTheater = "자동차 극장"
    case concert = "공연장-연극극장"
}

// MARK: - Case Iterable

extension CategoryDetailCultureList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailCultureList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Network

extension CategoryDetailCultureList {
    var parameterCategory: String {
        switch self {
        case .theater:
            return "CINEMA"
        case .driveInTheater:
            return "CAR_CINEMA"
        case .concert:
            return "CONCERT"
        }
    }
}
