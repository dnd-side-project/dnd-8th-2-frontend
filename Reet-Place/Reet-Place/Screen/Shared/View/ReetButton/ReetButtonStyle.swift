//
//  ReetButtonStyle.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/11.
//

import UIKit

/// Represents the style of default button
enum ReetButtonStyle: String {
  case primary
  case secondary
  case outlined
}

extension ReetButtonStyle: CaseIterable {}

// MARK: - Title Colors

extension ReetButtonStyle {
  /// The default color of title
  var defaultTitleColor: UIColor {
    switch self {
    case .primary,
        .secondary:
      return AssetColors.white
    case .outlined:
      return AssetColors.gray700
    }
  }
  
  /// The disabled color of title
  var disabledTitleColor: UIColor {
    AssetColors.gray300
  }
}

// MARK: - ButtonDefaultColorProvider

extension ReetButtonStyle: ButtonDefaultColorProvider {
  
  var defaultBackgroundColor: UIColor {
    switch self {
    case .primary:
      return AssetColors.primary500
    case .secondary:
      return AssetColors.black
    case .outlined:
      return AssetColors.white
    }
  }
  
  var defaultBorderColor: UIColor {
    switch self {
    case .primary,
        .secondary:
      return .clear
    case .outlined:
      return AssetColors.gray500
    }
  }
  
}

// MARK: - ButtonActiveColorProvider

extension ReetButtonStyle: ButtonActiveColorProvider {
  
  var activeBackgroundColor: UIColor {
    switch self {
    case .primary:
      return AssetColors.primary400
    case .secondary:
      return AssetColors.gray700
    case .outlined:
      return AssetColors.gray200
    }
  }
  
  var activeBorderColor: UIColor {
    switch self {
    case .primary,
        .secondary:
      return .clear
    case .outlined:
      return AssetColors.gray500
    }
  }
  
}

// MARK: - ButtonDisabledColorProvider

extension ReetButtonStyle: ButtonDisabledColorProvider {
  var disabledBackgroundColor: UIColor {
    AssetColors.gray100
  }
  
  var disabledBorderColor: UIColor {
    switch self {
    case .primary,
        .secondary:
      return .clear
    case .outlined:
      return AssetColors.gray300
    }
  }
}
