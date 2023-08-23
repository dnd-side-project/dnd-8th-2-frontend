//
//  MarkerType.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/07/19.
//

import UIKit

/// Represents the type of Reet-Place marker type
enum MarkerType {
    case round(State)
    case extended(State)
    
    enum State {
        case standard
        case wishlist
        case didVisit
    }
}

extension MarkerType {
    var image: UIImage {
        switch self {
        case .round(.standard):
            return AssetsImages.markerRoundDefault
        case .round(.wishlist):
            return AssetsImages.markerRoundWishlist
        case .round(.didVisit):
            return AssetsImages.markerRoundDidVisit
            
        case .extended(.standard):
            return AssetsImages.markerExtendedDefault
        case .extended(.wishlist):
            return AssetsImages.markerExtendedWishlist
        case .extended(.didVisit):
            return AssetsImages.markerExtendedDidVisit
        }
    }
}
