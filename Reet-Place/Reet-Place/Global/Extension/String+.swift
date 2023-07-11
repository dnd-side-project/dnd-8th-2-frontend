//
//  String+.swift
//  Reet-Place
//
//  Created by Aaron Lee on 2023/02/14.
//

import Foundation

extension String {
    static var empty: Self {
        ""
    }
    
    var localized: Self {
        NSLocalizedString(self, comment: .empty)
    }
    
    static var defaultThumbnailImageName: Self {
        "ProfilePlaceholder"
    }
    
}

extension Optional where Wrapped == String {
    var url: URL? {
        guard let self = self else{
            return nil
        }
        
        return URL(string: self)
    }
}
