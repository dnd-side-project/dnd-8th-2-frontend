//
//  BaseLabel.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/14.
//

import UIKit

class BaseLabel: UILabel {
  private let reetFont: AssetFonts
  private let alignment: NSTextAlignment?
  private let color: UIColor?
  
  init(frame: CGRect = .zero,
       font: AssetFonts,
       text: String?,
       alignment: NSTextAlignment? = nil,
       color: UIColor? = nil) {
    reetFont = font
    self.alignment = alignment
    self.color = color
    
    super.init(frame: frame)
    
    self.font = reetFont.font
    self.text = text
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var text: String? {
    didSet {
      let newAttributed: NSMutableAttributedString
      
      if let attributed = attributedText {
        newAttributed = NSMutableAttributedString(attributedString: attributed)
      } else {
        newAttributed = NSMutableAttributedString(string: text ?? "")
      }
      
      newAttributed.setAttr(with: reetFont,
                            alignment: alignment,
                            color: color)
      
      attributedText = newAttributed
    }
  }
  
}
