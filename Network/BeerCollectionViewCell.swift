//
//  BeerCollectionViewCell.swift
//  Network
//
//  Created by 민지은 on 2024/01/16.
//

import UIKit

class BeerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var beerIMG: UIImageView!
    @IBOutlet var beerName: UILabel!
    @IBOutlet var beerDescription: UILabel!
    @IBOutlet var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
