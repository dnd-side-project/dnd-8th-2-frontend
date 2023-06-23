//
//  CategoryDetailActivityList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum CategoryDetailActivityList: String {
    case bowlingAlley = "볼링장"
    case pcRoom = "피시방"
    case billiardHall = "당구장"
    case singingRoom = "노래방"
    case sportsFacility = "체육시설"
    case boardGameCafe = "보드게임 카페"
    case escapeRoom = "방탈출"
    case gameArcade = "게임장"
    case coinSingingRoom = "코인 노래방"
}

// MARK: - Case Iterable

extension CategoryDetailActivityList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailActivityList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}
