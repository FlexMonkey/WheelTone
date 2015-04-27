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
    private var originChanged: Bool = true
    
    private var rotationCount: Int = 0
    private var lastPingedRotationCount: Int = -1
    
    private let gearShape = CAShapeLayer()
    
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
        
        updateColorForState()
        
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
        if layer == self && event == "position"
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
            
            rotationCount = Int(rotation / CGFloat(M_PI * 2))
            
            if lastPingedRotationCount != rotationCount
            {
                println("ping!")
                
                lastPingedRotationCount = rotationCount
            }
        }
    }
    
    var origin: CGPoint
    {
        didSet
        {
            originChanged = true
            setNeedsDisplay();
        }
    }
    
    var frequency: Int?
    {
        didSet
        {
            updateColorForState()
        }
    }
    
    var selected: Bool = false
    {
        didSet
        {
            updateColorForState()
        }
    }

    func updateColorForState()
    {
        fillColor = selected ? UIColor.blueColor().CGColor : frequency == nil ? UIColor.lightGrayColor().CGColor : UIColor.darkGrayColor().CGColor
    }
    
    override func display()
    {
        super.display()

        let diameter = radius * 2
        let circumference = CGFloat(M_PI) * diameter

        let boundingBox = CGRect(x: -radius, y: -radius, width: diameter, height: diameter)
        
        if originChanged
        {
            frame.origin.x = origin.x
            frame.origin.y = origin.y
            
            originChanged = false
        }
        
        if rotationChanged || radiusChanged
        {
            var rotateTransform = CGAffineTransformMakeRotation(rotation)
            
            let gearPath = CGPathCreateMutable()
            
            CGPathAddEllipseInRect(gearPath, &rotateTransform, boundingBox)
            
            if frequency != nil
            {
                CGPathMoveToPoint(gearPath, &rotateTransform, 0, 0 - radius + 10)
                CGPathAddLineToPoint(gearPath, &rotateTransform, 0, 0)
            }
            
            gearShape.path = gearPath

            rotationChanged = false
        }
        
        if radiusChanged
        {
            gearShape.lineDashPattern = [circumference / 50]
            
            path = CGPathCreateWithEllipseInRect(boundingBox, nil)
            
            radiusChanged = false
        }
    }
}
