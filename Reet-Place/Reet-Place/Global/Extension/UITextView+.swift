//
//  UITextView+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension UITextView {
    
    /// UITextView를 드래그 불가 뷰어용으로 설정
    func setTextViewToViewer() {
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    
    /// UITextView 기본 padding값 설정
    func setPadding() {
        textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
    }
    
}
