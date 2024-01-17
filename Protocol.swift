//
//  Protocol.swift
//  Network
//
//  Created by 민지은 on 2024/01/16.
//

import UIKit

protocol ViewProtocol {
    func configureView()
}

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIViewController: ReusableProtocol {
    static var identifier: String {
        return String(describing: self)
    }
}
