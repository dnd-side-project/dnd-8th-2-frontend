//
//  NSMutableAttributedString+.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/14.
//

import UIKit

extension NSMutableAttributedString {
  func setAttr(with font: AssetFonts,
               alignment: NSTextAlignment? = nil,
               color: UIColor? = nil) {
    let range = (string as NSString).range(of: string)
    
    // Font
    addAttribute(.font,
                 value: font.font,
                 range: range)
    
    // Line height
    let paragraph = NSMutableParagraphStyle()
    paragraph.lineSpacing = font.lineHeightMultiplier
    
    if let alignment = alignment {
      paragraph.alignment = alignment
    }
    
    addAttribute(.paragraphStyle,
                 value: paragraph,
                 range: range)
    
    // Color
    if let color = color {
      addAttribute(.foregroundColor,
                   value: color,
                   range: range)
    }
    
    // Letter spacing
    let letterSpacingRange = NSRange(location: .zero, length: string.count - 1)
    
    addAttribute(.kern,
                 value: font.letterSpacingMultiplier - 1.0,
                 range: letterSpacingRange)
  }
}
