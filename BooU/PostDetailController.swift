//
//  PostDetailController.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 26/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class PostDetailController: UITableViewController {
    var MyActivity = true; var newCom: Comment!; var noComPic: UIImageView!
    var detailItem : Post!
    var detailItemIndex: Int! {
        didSet {
            self.tableView.reloadData();
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        YayMgr.myPosts.observe { e in
            self.setItemDetailObject()
            self.noComPic.hidden = (self.detailItem.Comments.count > 0) ? true : false
            self.tableView.reloadData()
        }
        YayMgr.FrPosts.observe { e in
            self.setItemDetailObject()
            self.noComPic.hidden = (self.detailItem.Comments.count > 0) ? true : false
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: true)
    }
    
    func setItemDetailObject(){
        if(MyActivity == true){
            detailItem = YayMgr.myPosts[detailItemIndex]
        }
        else {
            detailItem = YayMgr.FrPosts[detailItemIndex]
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        if(indexPath.row == 0){
            if(MyActivity == true){
                cell = tableView.dequeueReusableCellWithIdentifier("mPost", forIndexPath: indexPath) as UITableViewCell
                populateMyPost(detailItemIndex,isMyActivity: true,cell: cell)
            }
            else {
                cell = tableView.dequeueReusableCellWithIdentifier("fPost", forIndexPath: indexPath) as UITableViewCell
                let btn = cell.contentView.viewWithTag(20) as! UIButton
                btn.addTarget(self, action: "pointClick:", forControlEvents: .TouchUpInside)
                populateFriendPost(detailItemIndex,isMyActivity: false,cell: cell)
            }
        }
        else{
             cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as UITableViewCell
            
            let title = cell.contentView.viewWithTag(101) as! UILabel
            title.text = "\(detailItem.Comments[indexPath.row-1].Commentor.FirstName) \(detailItem.Comments[indexPath.row-1].Commentor.LastName)"
            if detailItem.Text.Yay {
                title.textColor = UIColor.Yay()
            } else {
                title.textColor = UIColor.Boo()
            }
            
            let duration = cell.contentView.viewWithTag(103) as! UILabel
            let diffMoment = moment() - moment(detailItem.Comments[indexPath.row-1].Timestamp)
            duration.text = getShortDurationDesc(diffMoment)
            
            
            let comment = cell.contentView.viewWithTag(102) as! UILabel
            comment.text = detailItem.Comments[indexPath.row-1].Comment
            let commentHeight = heightForView(comment.text!, font:comment.font, width:comment.frame.width)
     
            
            comment.frame = CGRect(x: comment.frame.origin.x, y: comment.frame.origin.y ,width:comment.frame.width ,height: commentHeight)
            let fPic = cell.contentView.viewWithTag(100) as! UIImageView
            
            fPic.layer.cornerRadius = 12
            fPic.layer.masksToBounds = true
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let mydata = NSData(contentsOfURL: NSURL(string: self.detailItem.Comments[indexPath.row-1].Commentor.PhotoUrl)!)
                dispatch_async(dispatch_get_main_queue()) {
                    if( mydata != nil){
                        fPic.image =  UIImage(data: mydata!)
                    }
                }
            })
        }


        return cell
    } 
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    


    func pointClick(sender: UIButton){
        playSound(YayMgr.FrPosts[Int(sender.accessibilityValue!)!].Text.Yay)
        YayMgr.addPoint(Int(sender.accessibilityValue!)!)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItem == nil ? 0 : detailItem.Comments.count+1
    }
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    @IBAction func cancel(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func post(segue: UIStoryboardSegue) {
        YayMgr.addComment(newCom, index: detailItemIndex, isMyactivity: MyActivity)
    }
    
}
