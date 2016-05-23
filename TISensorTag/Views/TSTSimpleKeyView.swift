//
//  TSTSimpleKeyView.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/21/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class TSTSimpleKeyView: UIView
{
    var depressedFrame : CGRect
    var pressedFrame : CGRect
    
    required init?(coder aDecoder: NSCoder)
    {
        self.depressedFrame = CGRectZero
        self.pressedFrame = CGRectZero

        super.init(coder: aDecoder)
    }

    func setup()
    {
        self.depressedFrame = self.frame
    
        self.pressedFrame = CGRectMake(self.frame.origin.x,
                                       self.frame.origin.y + self.frame.size.height * TSTConstants.SimpleKeyView.depressedPercent,
                                       self.frame.size.width,
                                       self.frame.size.height * (1.0 - TSTConstants.SimpleKeyView.depressedPercent))
    
        let cornerRadius : CGFloat = TSTConstants.SimpleKeyView.cornerRadius
        
        let bezierPath : UIBezierPath = UIBezierPath(roundedRect: self.bounds,
                                                     byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight],
                                                     cornerRadii: CGSizeMake(cornerRadius, cornerRadius))
    
        let shapeLayer : CAShapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.CGPath
    
        self.layer.mask = shapeLayer
    }
    
    func press()
    {
        self.frame = self.pressedFrame
    }
    
    func depress()
    {
        self.frame = self.depressedFrame
    }
}














