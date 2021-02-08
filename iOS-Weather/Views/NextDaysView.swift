//
//  NextDaysView.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 04/02/21.
//
import UIKit

@IBDesignable
class NextDaysView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var separator: UIView!
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
            "NextDaysView", owner: self, options: nil
        )
        addSubview(contentView)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func render(title: String, value: String, image: UIImage, imageColor: UIColor, defaultColor: UIColor) {
        self.labelTitle.text = title
        self.labelValue.text = value
        self.imageIcon.image = image
        self.imageIcon.tintColor = imageColor
        self.labelTitle.textColor = defaultColor
        self.labelValue.textColor = defaultColor
        self.separator.backgroundColor = defaultColor
    }
}
