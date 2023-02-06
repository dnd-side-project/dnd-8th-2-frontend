//
//  UIFont+.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

extension UIFont {
    
    // examples
    @nonobjc class var title1: UIFont{
        PretendardSemiBold(size: 28)
    }
    
    @nonobjc class var body1: UIFont{
        PretendardRegular(size: 17)
    }
    
    @nonobjc class var caption1: UIFont{
        PretendardRegular(size: 12)
    }
    
    // Basic example
    class func PretendardRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-Regular", size: size)!
    }
    
    class func PretendardSemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-SemiBold", size: size)!
    }
}
