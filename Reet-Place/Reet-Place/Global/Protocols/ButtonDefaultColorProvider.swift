//
//  ButtonDefaultColorProvider.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/11.
//

import UIKit

/// Provides default background / border color of a button
protocol ButtonDefaultColorProvider {
  /// Default background color
  var defaultBackgroundColor: UIColor { get }
  
  /// Default border color
  var defaultBorderColor: UIColor { get }
}
