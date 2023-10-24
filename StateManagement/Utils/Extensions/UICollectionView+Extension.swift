//
//  UICollectionView+Extension.swift
//  StateManagement
//
//  Created by Ye Lynn Htet on 10/24/23.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(from type: T.Type) {
        let nib = UINib(nibName: String(describing: T.self), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueCell<T: UICollectionViewCell>(from type: T.Type, at indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as! T
    }
    
}
