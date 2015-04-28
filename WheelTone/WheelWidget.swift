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
    static let frequencies: [CGFloat] = [130.813, 138.591, 146.832, 155.563, 164.814, 174.614, 184.997, 195.998, 207.652, 220, 233.082, 246.942, 261.626, 277.183, 293.665, 311.127, 329.628, 349.228, 369.994, 391.995, 415.305, 440.000, 466.164, 493.883, 523.251, 554.365, 587.330, 622.254, 659.255, 698.456, 739.989, 783.991, 830.609, 880, 932.328, 987.767 ].sorted({$0 > $1})
    
    private var rotationChanged: Bool = true
    private var radiusChanged: Bool = true
    private var originChanged: Bool = true
    
    private var rotationCount: Int = 0
    private var lastPingedRotationCount: Int = -1
    
    static let minRadius: CGFloat = 25
    static let maxRadius: CGFloat = 250
    
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
        
        drawsAsynchronously = true
        gearShape.drawsAsynchronously = true
        
        delegate = self
        gearShape.delegate = self
        
        gearShape.fillColor = nil
        gearShape.strokeColor = UIColor.redColor().CGColor
        gearShape.lineCap = kCALineCapButt
        gearShape.lineWidth = lineWidth
        addSublayer(gearShape)
        
        updateColorForState()
        
        setNeedsLayout()
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
        if layer == gearShape
        {
            return NSNull()
        }
        else if layer == self && (event == "onDraw" || event == "contents")
        {
            return NSNull()
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
            radius = min(max(radius, WheelWidget.minRadius), WheelWidget.maxRadius)
            
            if oldValue != radius
            {
                radiusChanged = true
                setNeedsLayout()
            }
        }
    }
    
    var rotation: CGFloat = 0
    {
        didSet
        {            
            rotationChanged = true
            setNeedsLayout()
      
            rotationCount = Int(rotation / CGFloat(M_PI * 2))
            
            if lastPingedRotationCount != rotationCount && frequency != nil
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
            setNeedsLayout();
        }
    }
    
    var frequency: CGFloat?
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
    
    override func layoutSublayers()
    {
        super.layoutSublayers()

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
    
    class func getFrequencyForRadius(radius: CGFloat) -> CGFloat
    {
        let index =  Int(round((radius - minRadius) / (maxRadius - minRadius) * CGFloat(frequencies.count - 1)))
        
        return frequencies[index]
    }
}
