//
//  HeaderLocationCell.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

class HeaderLocationCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        self.labelTitle.text = ""
    }
    
    func render(title: String) {
        self.labelTitle.text = title
    }
}
