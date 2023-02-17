//
//  AssetFonts.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/14.
//

import UIKit

enum AssetFonts: String {
  case h1
  case h2
  case h3
  case h4
  case subtitle1
  case subtitle2
  case body1
  case body2
  case caption
  case buttonLarge
  case buttonSmall
  case chip
  case inputText
  case tooltip
}

// MARK: - CaseIterable

extension AssetFonts: CaseIterable {}

extension AssetFonts {
  var font: UIFont {
    weight.font(size: size)
  }
}

// MARK: - Attributes

extension AssetFonts {
  var size: CGFloat {
    switch self {
    case .h1:
      return 48.0
    case .h2:
      return 32.0
    case .h3:
      return 24.0
    case .h4:
      return 20.0
    case .subtitle1:
      return 16.0
    case .subtitle2:
      return 14.0
    case .body1:
      return 16.0
    case .body2:
      return 14.0
    case .caption:
      return 12.0
    case .buttonLarge:
      return 15.0
    case .buttonSmall:
      return 14.0
    case .chip:
      return 14.0
    case .inputText:
      return 14.0
    case .tooltip:
      return 10.0
    }
  }
  
  fileprivate var weight: FontWeight {
    switch self {
    case .h1:
      return .bold
    case .h2:
      return .medium
    case .h3:
      return .medium
    case .h4:
      return .bold
    case .subtitle1:
      return .bold
    case .subtitle2:
      return .bold
    case .body1:
      return .regular
    case .body2:
      return .regular
    case .caption:
      return .regular
    case .buttonLarge:
      return .bold
    case .buttonSmall:
      return .bold
    case .chip:
      return .medium
    case .inputText:
      return .regular
    case .tooltip:
      return .medium
    }
  }
  
  var lineHeightMultiplier: CGFloat {
    switch self {
    case .h1:
      return 1.2
    case .h2:
      return 1.2
    case .h3:
      return 1.2
    case .h4:
      return 1.2
    case .subtitle1:
      return 1.5
    case .subtitle2:
      return 1.5
    case .body1:
      return 1.5
    case .body2:
      return 1.5
    case .caption:
      return 1.2
    case .buttonLarge:
      return 1.1
    case .buttonSmall:
      return 1.15
    case .chip:
      return 1.15
    case .inputText:
      return 1.2
    case .tooltip:
      return 1.2
    }
  }
  
  var letterSpacingMultiplier: CGFloat {
    switch self {
    case .h1:
      return 1.0
    case .h2:
      return 1.0
    case .h3:
      return 0.98
    case .h4:
      return 0.98
    case .subtitle1:
      return 0.98
    case .subtitle2:
      return 0.98
    case .body1:
      return 0.98
    case .body2:
      return 0.98
    case .caption:
      return 0.98
    case .buttonLarge:
      return 1.0
    case .buttonSmall:
      return 1.0
    case .chip:
      return 1.0
    case .inputText:
      return 1.0
    case .tooltip:
      return 1.0
    }
  }
}

// MARK: - Font weight

fileprivate enum FontWeight: String {
  case bold
  case semibold
  case medium
  case regular
}

extension FontWeight {
  func font(size: CGFloat) -> UIFont {
    UIFont(name: "Pretendard-\(rawValue.capitalized)",
           size: size)!
  }
}
