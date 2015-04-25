//
//  ViewController.swift
//  WheelTone
//
//  Created by Simon Gladman on 25/04/2015.
//  Copyright (c) 2015 Simon Gladman. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let widget = WheelWidget(radius: 100, origin: CGPoint(x: 100, y: 100))
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.layer.addSublayer(widget)

        let pinch = UIPinchGestureRecognizer(target: self, action: "pinchHandler:")
        view.addGestureRecognizer(pinch)
    
        let pan = UIPanGestureRecognizer(target: self, action: "panHandler:")
        pan.maximumNumberOfTouches = 1
        view.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var initialPanOrigin: CGPoint?
    
    func panHandler(recognizer: UIPanGestureRecognizer)
    {
        switch recognizer.state
        {
        case .Began:
            initialPanOrigin = recognizer.locationInView(self.view)
        case .Changed:
            widget.origin.x = widget.origin.x + recognizer.locationInView(self.view).x - initialPanOrigin!.x
            widget.origin.y = widget.origin.y + recognizer.locationInView(self.view).y - initialPanOrigin!.y
            
            initialPanOrigin = recognizer.locationInView(self.view)
        default:
            initialPanOrigin = nil
        }
    }

    var initialPinchRadius: CGFloat?
    
    func pinchHandler(recognizer: UIPinchGestureRecognizer)
    {
        switch recognizer.state
        {
        case .Began:
            initialPinchRadius = widget.radius
        case .Changed:
            widget.radius = initialPinchRadius! * recognizer.scale
        default:
            initialPinchRadius = nil
        }
    }
    
    /*
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        let touch = touches.first as? UITouch

        if let origin = touch?.locationInView(self.view)
        {
            widget.origin = origin
        }
    }
*/
    
}

