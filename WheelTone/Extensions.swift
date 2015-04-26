//
//  Extensions.swift
//  WheelTone
//
//  Created by Simon Gladman on 26/04/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import CoreGraphics

extension CGPoint
{
    func distance(otherPoint: CGPoint) -> CGFloat
    {
        let xSquare = (self.x - otherPoint.x) * (self.x - otherPoint.x)
        let ySquare = (self.y - otherPoint.y) * (self.y - otherPoint.y)
        
        return sqrt(xSquare + ySquare)
    }
}
