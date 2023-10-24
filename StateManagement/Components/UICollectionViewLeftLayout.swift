//
//  UICollectionViewLeftLayout.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation
import UIKit

class UICollectionViewLeftLayout: UICollectionViewFlowLayout {
    
    var spacing = 0.1

    func setSpacing(_ value: Double) {
        self.spacing = value
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var rows = [CollectionViewRow]()
        var currentRowY: CGFloat = -1

        for attribute in attributes {
            if currentRowY != attribute.frame.midY {
                currentRowY = attribute.frame.midY
                rows.append(CollectionViewRow(spacing: spacing))
            }
            rows.last?.add(attribute: attribute)
        }

        rows.forEach { $0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? 0) }
        return rows.flatMap { $0.attributes }
    }
}
