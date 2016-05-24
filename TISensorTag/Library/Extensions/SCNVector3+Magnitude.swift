//
//  SCNVector3+Magnitude.swift
//  TISensorTag
//
//  Created by Andre Muis on 5/22/16.
//  Copyright © 2016 Andre Muis. All rights reserved.
//

import SceneKit

extension SCNVector3
{
    var magnitude : Float
    {
        return sqrt(pow(self.x, 2.0) + pow(self.y, 2.0) + pow(self.z, 2.0))
    }
}