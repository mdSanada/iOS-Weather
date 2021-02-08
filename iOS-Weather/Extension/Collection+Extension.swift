//
//  Collection+Extension.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

extension UICollectionView {
    func register(type: UICollectionViewCell.Type) {
        self.register(UINib(nibName: type.reuseIdentifier, bundle: nil),
                      forCellWithReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueReusableCell<Type: UICollectionViewCell> (_ indexPath: IndexPath) -> Type {
        return dequeueReusableCell(
            withReuseIdentifier: Type.self.reuseIdentifier,
            for: indexPath) as! Type
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}
