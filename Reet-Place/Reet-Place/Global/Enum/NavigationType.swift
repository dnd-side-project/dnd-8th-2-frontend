//
//  NaviType.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/02/04.
//

import UIKit

enum NavigationType {
    case push
    case present
}

extension NavigationType {
    var popButtonImage: UIImage {
        switch self {
        case .push:
            return UIImage(named: "pop") ?? UIImage()
        case .present:
            return UIImage(named: "dismiss") ?? UIImage()
        }
    }
}
