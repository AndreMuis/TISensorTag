//
//  STGBarGaugeView.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/16/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import UIKit

class STGBarGaugeView : UIView
{
    var indicatorView : UIView!
    
    var normalizedReading : Float!
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
            
            self.indicatorView.frame = CGRect(x: self.indicatorView.frame.origin.x,
                                              y: self.indicatorView.frame.origin.y,
                                              width: CGFloat(self.normalizedReading) * self.frame.size.width,
                                              height: self.indicatorView.frame.size.height)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)

        self.indicatorView = nil
        
        self.normalizedReading = 0.0
    }
    
    func setupWithBackgroundColor(backgroundColor : UIColor, indicatorColor : UIColor)
    {
        self.backgroundColor = backgroundColor;
        
        self.indicatorView = UIView(frame: CGRectMake(0.0, 0.0, 0.0, self.frame.size.height))
        self.addSubview(self.indicatorView)
        
        self.indicatorView.backgroundColor = indicatorColor;
    }
}
