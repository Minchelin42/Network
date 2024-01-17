//
//  LanguageTableViewCell.swift
//  Network
//
//  Created by 민지은 on 2024/01/17.
//

import UIKit

class LanguageTableViewCell: UITableViewCell {
    
    @IBOutlet var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        languageLabel.font = .systemFont(ofSize: 14, weight: .semibold)

    }
}
