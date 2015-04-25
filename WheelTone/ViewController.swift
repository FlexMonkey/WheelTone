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
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        let touch = touches.first as? UITouch
        
        if let origin = touch?.locationInView(self.view)
        {
            widget.origin = origin
        }
    }
    
}

