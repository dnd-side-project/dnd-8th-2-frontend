//
//  UITextField+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension UITextField {
    
    /// UITextField - 해당 값 만큼 왼쪽에 여백 추가
    func addLeftPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = ViewMode.always
    }
    
}
