//
//  ButtonDisabledColorProvider.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/11.
//

import UIKit

/// Provides disabled background / border color of a button
protocol ButtonDisabledColorProvider {
  /// Disabled background color
  var disabledBackgroundColor: UIColor { get }
  
  /// Disabled border color
  var disabledBorderColor: UIColor { get }
}
