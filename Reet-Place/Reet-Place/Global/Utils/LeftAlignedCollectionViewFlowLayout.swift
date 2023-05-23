//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Reet-Place
//
//  Created by Kim HeeJae on 2023/05/18.
//

import UIKit

/// CollectionView의 Item을 왼쪽(Left)으로 정렬(Alignment)하는 Custom CollectionViewFlowLayout
class LeftAlignmentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Override
    
    override func layoutAttributesForElements(in rect: CGRect) ->  [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() as! UICollectionViewLayoutAttributes }
        var leftMargin: CGFloat = 0.0
        var maxY: CGFloat = -1.0
    
        attributes?.forEach { layoutAttribute in
            guard layoutAttribute.representedElementCategory == .cell else {
                return
            }

            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = 0.0
            }
            layoutAttribute.frame.origin.x = leftMargin
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
    
}
