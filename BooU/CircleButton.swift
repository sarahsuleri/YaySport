//
//  CircleButton.swift
//  TableViewTest
//
//  Created by Daria on 29.10.15.
//  Copyright © 2015 Predic8. All rights reserved.
//

import UIKit

@IBDesignable class CircleButton: UIButton {

    @IBInspectable var fillColor: UIColor = UIColor.Yay()
    
    override func drawRect(rect: CGRect) {
        
        let path = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        path.fill()
        
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 3.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
            
        //create the path
        let plusPath = UIBezierPath()
            
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
            
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 - plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
            
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + plusWidth/2 + 0.5,
            y:bounds.height/2 + 0.5))
        
        //Vertical Line
        //move to the start of the vertical stroke
        plusPath.moveToPoint(CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - plusWidth/2 + 0.5))
            
        //add the end point to the vertical stroke
        plusPath.addLineToPoint(CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + plusWidth/2 + 0.5))
            
        //set the stroke color
        UIColor.whiteColor().setStroke()
            
        //draw the stroke
        plusPath.stroke()
    }
}
