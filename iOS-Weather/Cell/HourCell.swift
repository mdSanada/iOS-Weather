//
//  HourCell.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

class HourCell: UICollectionViewCell {
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        self.labelDate.text = ""
        self.labelTemp.text = ""
        self.imageIcon.image = nil
    }
    
    func render(date: String, temp: Double, image: UIImage, color: UIColor, accentColor: UIColor) {
        self.labelDate.text = date
        self.labelTemp.text = temp.toCelsius()
        self.imageIcon.image = image
        self.imageIcon.tintColor = accentColor
        self.labelDate.textColor = color
        self.labelTemp.textColor = color
    }
}
