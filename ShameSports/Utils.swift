//
//  Utils.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import ImageIO

extension UIColor {
    
    class func Yay() -> UIColor {
        return UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 1.0)
    }
    
    class func Boo() -> UIColor {
        return UIColor(red: 155/255.0, green: 89/255.0, blue:182/255.0, alpha: 1.0)
    }
    class func YayLite() -> UIColor {
        return UIColor(red: 26/255.0, green: 188/255.0, blue: 156/255.0, alpha: 0.01)
    }
    
    class func BooLite() -> UIColor {
        return UIColor(red: 155/255.0, green: 89/255.0, blue:182/255.0, alpha: 0.01)
    }
}

func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
    
    
    let scale = CGFloat(max(size.width/image.size.width,
        size.height/image.size.height))
    let width:CGFloat  = image.size.width * scale
    let height:CGFloat = image.size.height * scale;
    
    let rr:CGRect = CGRectMake( 0, 0, width, height);
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    image.drawInRect(rr)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    return newImage
}

func convertStringToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
            return json
        } catch {
            print("Something went wrong")
        }
    }
    return nil
}