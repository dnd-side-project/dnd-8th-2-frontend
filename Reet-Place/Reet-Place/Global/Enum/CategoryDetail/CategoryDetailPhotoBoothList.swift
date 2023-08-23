//
//  CategoryDetailPhotoBoothList.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/13.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

enum CategoryDetailPhotoBoothList: String {
    case lifefourcuts = "인생네컷"
    case photosignature = "포토시그니처"
    case haruflim = "하루필름"
    case sihyunhadaFrame = "시현하다FRAME"
    case monomansion = "모노맨션"
    case rgbphotostudio = "RGB포토"
    case photoism = "포토이즘"
    case instantPhoto = "즉석사진"
}

// MARK: - Case Iterable

extension CategoryDetailPhotoBoothList: CaseIterable {}

// MARK: - Custom String Convertible

extension CategoryDetailPhotoBoothList: CustomStringConvertible {
    var description: String {
        rawValue.localized
    }
}

// MARK: - Network

extension CategoryDetailPhotoBoothList {
    var parameterCategory: String {
        switch self {
        case .lifefourcuts:
            return "LIFE_FOUR_CUT"
        case .photosignature:
            return "PHOTO_SIGNATURE"
        case .haruflim:
            return "HARU_FILM"
        case .sihyunhadaFrame:
            return "SIHYUN_HADA"
        case .monomansion:
            return "MONO_MANSION"
        case .rgbphotostudio:
            return "RGB_PHOTO"
        case .photoism:
            return "PHOTOISM"
        case .instantPhoto:
            return .empty // TODO: - 해당 항목 추가 요청(추가 된 항목)
        }
    }
}
