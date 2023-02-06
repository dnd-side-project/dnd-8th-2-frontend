//
//  UILabel+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension UILabel {
    
    /// UILabel - 자간 조정
    var letterSpacing: CGFloat {
        set {
            let attributedString: NSMutableAttributedString
            if let currentAttrString = attributedText {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.text ?? "")
                self.attributedText = attributedString
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
            self.attributedText = attributedString
        }
        get {
            if let currentLetterSpace = attributedText?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    /// UILabel - 여러 줄 보기
    func setLineBreakMode() {
        translatesAutoresizingMaskIntoConstraints = false
        numberOfLines = 0
        lineBreakMode = .byCharWrapping
    }
    
}
