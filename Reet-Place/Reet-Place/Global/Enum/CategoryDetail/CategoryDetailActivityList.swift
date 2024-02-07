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

/// 액티비티
enum CategoryDetailActivityList: String {
    case bowlingAlley = "볼링장"
    case pcRoom = "피시방"
    case billiardHall = "당구장"
    case singingRoom = "노래방"
    case sportsFacility = "체육시설"
    case boardGameCafe = "보드게임 카페"
    case escapeRoom = "방탈출"
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

// MARK: - Network

extension CategoryDetailActivityList {
    var parameterCategory: String {
        switch self {
        case .bowlingAlley:
            return "BOWLING"
        case .pcRoom:
            return "PC"
        case .billiardHall:
            return "BILLIARDS"
        case .singingRoom:
            return "KARAOKE"
        case .sportsFacility:
            return "SPORTS"
        case .boardGameCafe:
            return "BOARD_GAME"
        case .escapeRoom:
            return "ROOM_ESCAPE"
        case .coinSingingRoom:
            return "COIN_KARAOKE"
        }
    }
}
