//
//  UIImageView+.swift
//  Reet-Place
//
//  Created by 김태현 on 2023/04/16.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String, placeholder: UIImage) {
        ImageCache.default.retrieveImage(forKey: urlString, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    //캐시가 존재하는 경우
                    self.image = image
                } else {
                    //캐시가 존재하지 않는 경우
                    guard let url = URL(string: urlString) else { return }
                    let resource = Kingfisher.ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource, placeholder: placeholder)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
