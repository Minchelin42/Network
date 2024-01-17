//
//  BookCollectionViewCell.swift
//  Network
//
//  Created by 민지은 on 2024/01/17.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var bookIMG: UIImageView!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var rectView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookIMG.contentMode = .scaleAspectFill
        
        rectView.layer.cornerRadius = 15
        rectView.layer.borderWidth = 2
        rectView.layer.borderColor = UIColor.gray.cgColor
        
        authorLabel.font = .systemFont(ofSize: 12)
        
        
        authorNameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        authorNameLabel.numberOfLines = 0
        authorNameLabel.textAlignment = .right
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

    }

}
