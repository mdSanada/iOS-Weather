//
//  SearchCell.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 05/02/21.
//

import UIKit

class SearchCell: UITableViewCell {
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func render(city: String, country: String) {
        self.labelCity.text = city
        self.labelCountry.text = country
    }
}
