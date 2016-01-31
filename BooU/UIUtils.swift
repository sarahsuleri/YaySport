//
//  UIUtils.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 27/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

func populateMyPost (index : Int, isMyActivity : Bool, cell : UITableViewCell) -> UITableViewCell {
    let object : Post!
    if(isMyActivity == true){
        object = YayMgr.myPosts[index]
    }
    else {
        object = YayMgr.FrPosts[index]
    }
    let points = cell.contentView.viewWithTag(10) as! UILabel
    let title = cell.contentView.viewWithTag(50) as! UILabel
    let comCount = cell.contentView.viewWithTag(80) as! UILabel
    let des = cell.contentView.viewWithTag(60) as! UILabel
    let comPics = cell.contentView.viewWithTag(70)! as UIView
    
    title.text = object.Text.Title
    comCount.text = String(object.Comments.count)
    des.text = object.Text.Description
    
    if(object.Text.Yay) {
        
        points.text = "+" + String(object.Points.count)
        title.textColor  = UIColor.Yay()
        points.textColor = UIColor.Yay()
        cell.backgroundColor = UIColor.YayLite()
    }
    else {
        points.text = "-" + String(object.Points.count)
        points.textColor = UIColor.Boo()
        title.textColor  = UIColor.Boo()
        cell.backgroundColor = UIColor.BooLite()
    }
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        var picLocation = CGFloat(0)
        for item in object.Comments {
            let cellImg : UIImageView = UIImageView(frame: CGRectMake(picLocation, 0, 16, 16))
            picLocation += 18
            cellImg.layer.cornerRadius = 8
            cellImg.layer.masksToBounds = true
            let mydata = NSData(contentsOfURL: NSURL(string: item.Commentor.PhotoUrl)!)
            dispatch_async(dispatch_get_main_queue()) {
                
                if( mydata != nil){
                    
                    cellImg.image = resizeImage(UIImage(data: mydata!)!, toTheSize: CGSize(width: 16, height: 16))
                    comPics.addSubview(cellImg)
                }
            }
        }
    }
    
    return cell
}

func populateFriendPost (index : Int, isMyActivity : Bool, cell : UITableViewCell) -> UITableViewCell {
    let object : Post!
    if(isMyActivity == true){
        object = YayMgr.myPosts[index]
    }
    else {
        object = YayMgr.FrPosts[index]
    }
    let points = cell.contentView.viewWithTag(10) as! UILabel
    let name = cell.contentView.viewWithTag(40) as! UILabel
    let title = cell.contentView.viewWithTag(50) as! UILabel
    let comCount = cell.contentView.viewWithTag(80) as! UILabel
    let des = cell.contentView.viewWithTag(60) as! UILabel
    let btn = cell.contentView.viewWithTag(20) as! UIButton
    let fPic = cell.contentView.viewWithTag(30) as! UIImageView
    let comPics = cell.contentView.viewWithTag(70)! as UIView
    
    btn.accessibilityValue = String(index)
   
     
    
    name.text = object.Poster.FirstName + ":"
    title.text = object.Text.Title
    comCount.text = String(object.Comments.count)
    des.text = object.Text.Description
    fPic.layer.cornerRadius = 12
    fPic.layer.masksToBounds = true
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
        let mydata = NSData(contentsOfURL: NSURL(string: object.Poster.PhotoUrl)!)
        dispatch_async(dispatch_get_main_queue()) {
            if( mydata != nil){
                fPic.image =  UIImage(data: mydata!)
            }
        }
    })
    
    if(object.Text.Yay){
        
        points.text = "+" + String(object.Points.count)
        name.textColor  = UIColor.Yay()
        points.textColor = UIColor.Yay()
        btn.setTitle("Yay!", forState: .Normal)
        btn.backgroundColor  = UIColor.Yay()
        cell.backgroundColor = UIColor.YayLite()
    }
    else {
        points.text = "-" + String(object.Points.count)
        points.textColor = UIColor.Boo()
        name.textColor  = UIColor.Boo()
        btn.setTitle("Boo!", forState: .Normal)
        btn.backgroundColor  = UIColor.Boo()
        cell.backgroundColor = UIColor.BooLite()
    }
    
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
        var picLocation = CGFloat(0)
        for item in object.Comments {
            let cellImg : UIImageView = UIImageView(frame: CGRectMake(picLocation, 0, 16, 16))
            picLocation += 18
            cellImg.layer.cornerRadius = 8
            cellImg.layer.masksToBounds = true
            let mydata = NSData(contentsOfURL: NSURL(string: item.Commentor.PhotoUrl)!)
            dispatch_async(dispatch_get_main_queue()) {
                
                if( mydata != nil){
                    
                    cellImg.image = resizeImage(UIImage(data: mydata!)!, toTheSize: CGSize(width: 16, height: 16))
                    comPics.addSubview(cellImg)
                }
            }
        }
    }
    
    return cell
}



func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}


