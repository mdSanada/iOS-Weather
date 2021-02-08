//
//  Table+Extension.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 05/02/21.
//

import UIKit

extension UITableView {
    func register(type: UITableViewCell.Type) {
        self.register(UINib(nibName: type.reuseIdentifier, bundle: nil), forCellReuseIdentifier: type.reuseIdentifier)
    }

    func dequeueReusableCell<Type: UITableViewCell> (_ indexPath: IndexPath) -> Type {
        return dequeueReusableCell(
            withIdentifier: Type.self.reuseIdentifier,
            for: indexPath) as! Type
    }
}

extension UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}
