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
