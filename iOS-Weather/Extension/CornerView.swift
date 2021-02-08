//
//  CornerView.swift
//  iOS-Weather
//
//  Created by Matheus D Sanada on 03/02/21.
//
import UIKit

@IBDesignable
class CornerView: UIView {
// MinX MinY = top left
// MinX MaxY = bottom left
// MaxX MinY = top right
// MaxX MaxY = bottom right
// __________________________
// |0                      1|
// |                        |
// |                        |
// |2                      3|
// |________________________|
//
//    0 = no corner is being rounded
//    1 = top left corner rounded only
//    2 = top right corner rounded only
//    3 = top left and top right corners rounded only
//    4 = bottom left corner rounded only
//    5 = top left and bottom left corners rounded only
//    6 = top right and bottom left corners rounded only
//    7 = top left, top right and bottom left corners rounded only
//    8 = bottom right corner rounded only
//    9 = top left and bottom right corners rounded only
//   10 = top right and bottom right corners rounded only
//   11 = top left, top right and bottom right corners rounded only
//   12 = bottom left and bottom right corners rounded only
//   13 = top left, bottom left and bottom right corners rounded only
//   14 = top right, bottom left and bottom right corners rounded only
//   15 = all corners rounded

    
    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = radius
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var corners: Int = 0 {
        didSet {
            self.layer.maskedCorners = CACornerMask(rawValue: UInt(corners))
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var maskToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = maskToBounds
            self.setNeedsDisplay()
        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
