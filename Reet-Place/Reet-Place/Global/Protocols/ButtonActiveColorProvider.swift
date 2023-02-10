//
//  ButtonActiveColorProvider.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/11.
//

import UIKit

/// Provides active(pressed) background / border color of a button
protocol ButtonActiveColorProvider {
  /// Active background color
  var activeBackgroundColor: UIColor { get }
  
  /// Active border color
  var activeBorderColor: UIColor { get }
}
