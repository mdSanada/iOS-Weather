//
//  LocationCell.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//

import UIKit

class LocationCell: UICollectionViewCell {
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelTemp: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var imageBackground: CornerImage!
    
    let loadingView = UIView()
    let activityIndicator = UIActivityIndicatorView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                activityIndicator.startAnimating()
                setupLoadingView()
            } else {
                loadingView.removeFromSuperview()
                activityIndicator.stopAnimating()
            }
        }
    }
    
    var isLocation: Bool = false {
        didSet {
            locationImage.isHidden = !isLocation
        }
    }
    
    
    func setupLoadingView() {
        loadingView.addSubview(activityIndicator)
        loadingView.layer.cornerRadius = 15
        loadingView.layer.masksToBounds = true
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        self.contentView.addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        activityIndicator.style = .large
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
    }
    
    override func prepareForReuse() {
        self.labelCity.text = ""
        self.labelCountry.text = ""
        self.labelTemp.text = ""
        self.imageBackground.image = nil
    }
    
    func render(city: String, country: String, temp: Int, image: UIImage, isLoading: Bool, isLocation: Bool = false, color: UIColor) {
        self.labelCity.text = city
        self.labelCountry.text = country
        self.labelTemp.text = temp.toCelsius()
        self.labelCity.textColor = color
        self.labelCountry.textColor = color
        self.labelTemp.textColor = color
        self.imageBackground.image = image
        self.isLoading = isLoading
        self.isLocation = isLocation
    }

}
