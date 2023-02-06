//
//  UIView+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension UIView {
    
    /// UIView - 다수의 Subviews를 한번에 추가
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
    
    /// 클래스 이름을 String형으로 반환
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    /// UIView를 담당하는 viewController를 찾아서 리턴
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    /// UIView에 라운드 코너값 설정
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    /// UIView 상단에만 라운드 코너값 설정
    func roundCornersOnlyTop(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner,
                               .layerMinXMinYCorner]
    }
    
    /// UIView에 shadow 추가
    func addShadow(opacity: Float = 0.15) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
    }
    
}
