//
//  UIScrollView+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension UIScrollView {
    
    var bottomOffset: Double {
        contentSize.height - bounds.size.height + contentInset.bottom
    }
    
    /// UIScrollView - 최상단으로 스크롤
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: 0)
        setContentOffset(topOffset, animated: true)
    }
    
    /// UIScrollView - 최하단으로 스크롤
    func scrollToBottom(animated: Bool) {
      if self.contentSize.height < self.bounds.size.height { return }
        let bottomOffset = CGPoint(x: 0, y: bottomOffset)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// UIScrollView - 지정 offset으로 스크롤 (offset y)
    func scrollToVerticalOffset(offset: Double, animated: Bool = true) {
        let bottomOffset = CGPoint(x: 0, y: offset)
        setContentOffset(bottomOffset, animated: animated)
    }
    
    /// UIScrollView - 지정 offset으로 스크롤 (offset x)
    func scrollToHorizontalOffset(offset: Double, animated: Bool = true) {
        let bottomOffset = CGPoint(x: offset, y: 0)
        setContentOffset(bottomOffset, animated: animated)
    }
    
}
