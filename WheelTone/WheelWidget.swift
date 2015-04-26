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
    private var rotationChanged: Bool = true
    private var radiusChanged: Bool = true
    private var previousRadius: CGFloat = 0
    
    private var gearShape = CAShapeLayer()
    
    required init(radius: CGFloat, origin: CGPoint)
    {
        self.radius = radius
        self.origin = origin
        
        super.init()
        
        masksToBounds = false
        
        frame = CGRect(x: origin.x, y: origin.y, width: 1, height: 1)
        
        lineWidth = 10
        
        strokeColor = UIColor.darkGrayColor().CGColor
        fillColor = UIColor.lightGrayColor().CGColor
        
        delegate = self
      
        gearShape.fillColor = nil
        gearShape.strokeColor = UIColor.redColor().CGColor
        gearShape.lineCap = kCALineCapButt
        gearShape.lineWidth = lineWidth
        addSublayer(gearShape)
        
        setNeedsDisplay()
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
    
    override func actionForLayer(layer: CALayer!, forKey event: String!) -> CAAction!
    {
        if layer == self && event == "lineDashPhase"
        {
            return nil
        }
        else if layer == self && event == "position"
        {
            let animation = CABasicAnimation(keyPath: event)
            animation.duration = 0.075
            return animation
        }
        else
        {
            return nil
        }
    }

    var radius: CGFloat
    {
        didSet
        {
            radius = min(max(radius, 50), 250)
            
            if oldValue != radius
            {
                previousRadius = radius
                radiusChanged = true
            }
            
            setNeedsDisplay()
        }
    }
    
    var rotation: CGFloat = 0
    {
        didSet
        {
            rotationChanged = true
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
    
    var selected: Bool = false
    {
        didSet
        {
            fillColor = selected ? UIColor.blueColor().CGColor : UIColor.lightGrayColor().CGColor
        }
    }
    
    var gearPath = CGPathCreateMutable()
    
    override func display()
    {
        super.display()

        let diameter = radius * 2
        let circumference = CGFloat(M_PI) * diameter

        frame.origin.x = origin.x
        frame.origin.y = origin.y
        
        let boundingBox = CGRect(x: -radius, y: -radius, width: diameter, height: diameter)
  
        if radiusChanged || rotationChanged
        {
            var tx = CGAffineTransformMakeRotation(rotation)
            
            if radiusChanged
            {
                gearShape.path = CGPathCreateWithEllipseInRect(boundingBox, &tx)
                gearShape.lineDashPattern = [circumference / 60]
            }
            else
            {
                gearShape.path = CGPathCreateCopyByTransformingPath(gearShape.path, &tx)
            }

            rotationChanged = false
        }
        
        if radiusChanged
        {
            path = CGPathCreateWithEllipseInRect(boundingBox, nil)
            
            radiusChanged = false
        }
    }
}
