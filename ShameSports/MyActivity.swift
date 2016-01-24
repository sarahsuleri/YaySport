//
//  MyActivity.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class MyActivity: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //YayMgr.load()
        //print("MyPosts size here: ", YayMgr.myPosts.count)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("My View will appear")
        super.viewWillAppear(animated)
        //YayMgr.loadMessages()
        print("All yays: ", YayMgr.YayMsg.count)
        print("All boos: ", YayMgr.BooMsg.count)
        //YayMgr.load()
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = YayMgr.myPosts[indexPath.row]
        
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
        
        var picLocation = CGFloat(0)
        for item in object.Comments {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                
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
                
            })
            
        }
        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return YayMgr.myPosts.count
    }


}
