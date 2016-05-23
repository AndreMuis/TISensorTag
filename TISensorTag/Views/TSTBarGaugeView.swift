//
//  TSTBarGaugeView.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/16/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class TSTBarGaugeView : UIView
{
    var indicatorView : UIView?
    
    required init?(coder aDecoder: NSCoder)
    {
        self.indicatorView = nil
        
        normalizedReading = 0.0

        super.init(coder: aDecoder)
    }
    
    var normalizedReading : Float
    {
        didSet
        {
            if self.normalizedReading < 0.0
            {
                self.normalizedReading = 0.0
            }
            else if self.normalizedReading > 1.0
            {
                self.normalizedReading = 1.0
            }
            
            if let view : UIView = self.indicatorView
            {
                view.frame = CGRect(x: view.frame.origin.x,
                                    y: view.frame.origin.y,
                                    width: CGFloat(self.normalizedReading) * self.frame.size.width,
                                    height: view.frame.size.height)
            }
        }
    }
    
    func setup(backgroundColor backgroundColor : UIColor, indicatorColor : UIColor)
    {
        self.backgroundColor = backgroundColor
        
        let indicatorView : UIView = UIView(frame: CGRectMake(0.0, 0.0, 0.0, self.frame.size.height))
        
        self.indicatorView = indicatorView
        self.addSubview(indicatorView)
        
        indicatorView.backgroundColor = indicatorColor
    }
}















