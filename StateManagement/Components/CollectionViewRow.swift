//
//  CollectionViewRow.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import Foundation
import UIKit

class CollectionViewRow {
    var attributes = [UICollectionViewLayoutAttributes]()
    var spacing: CGFloat = 0

    init(spacing: CGFloat) {
        self.spacing = spacing
    }

    func add(attribute: UICollectionViewLayoutAttributes) {
        attributes.append(attribute)
    }

    var rowWidth: CGFloat {
        return attributes.reduce(0, { result, attribute -> CGFloat in
            return result + attribute.frame.width
        }) + CGFloat(attributes.count - 1) * spacing
    }

    func centerLayout(collectionViewWidth: CGFloat) {
        let padding = (collectionViewWidth - rowWidth) / 2
        var offset = padding
        for attribute in attributes {
            attribute.frame.origin.x = offset
            offset += attribute.frame.width + spacing
        }
    }
    
    func tagLayout(collectionViewWidth: CGFloat) {
//        let padding = 12
        var offset = 0
        for attribute in attributes {
            attribute.frame.origin.x = CGFloat(offset)
            offset += Int(attribute.frame.width + spacing)
        }
    }
}
