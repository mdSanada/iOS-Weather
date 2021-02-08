//
//  DetailsView.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//

import UIKit

@IBDesignable
class DetailsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        setupUI()
    }

    func setupUI() {
        Bundle.main.loadNibNamed(
            "DetailsView", owner: self, options: nil
        )
        addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func render(title: String, value: String, image: UIImage, color: UIColor) {
        self.labelTitle.text = title
        self.labelValue.text = value
        self.imageIcon.image = image
        self.labelTitle.textColor = color
        self.labelValue.textColor = color
        self.imageIcon.tintColor = color

    }
}
