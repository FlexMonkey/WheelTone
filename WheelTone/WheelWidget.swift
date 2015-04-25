//
//  WheelWidget.swift
//  WheelTone
//
//  Created by Simon Gladman on 25/04/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit

class WheelWidget: CAShapeLayer
{
    required init(radius: CGFloat, origin: CGPoint)
    {
        self.radius = radius
        self.origin = origin
        
        super.init()
        
        masksToBounds = false
        
        frame = CGRect(x: origin.x, y: origin.y, width: 1, height: 1)
        
        lineCap = kCALineCapRound
        lineWidth = 6
        
        strokeColor = UIColor.darkGrayColor().CGColor
        fillColor = UIColor.lightGrayColor().CGColor
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: AnyObject!)
    {
        if let layer = layer as? WheelWidget
        {
            radius = layer.radius
            origin = layer.origin
        }
        else
        {
            radius = 0
            origin = CGPointZero
        }
        
        super.init(layer: layer)
    }
    
    var radius: CGFloat
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    var origin: CGPoint
    {
        didSet
        {
            setNeedsDisplay();
        }
    }
    
    override func display()
    {
        super.display()

        let diameter = radius * 2
        let circumference = CGFloat(M_PI) * diameter
   
        let boundingBox = CGRect(x: -radius, y: -radius, width: diameter, height: diameter)
        
        frame.origin.x = origin.x
        frame.origin.y = origin.y
        
        lineDashPattern = [circumference / 40, circumference / 40]
        path = CGPathCreateWithEllipseInRect(boundingBox, nil)
    }
}
