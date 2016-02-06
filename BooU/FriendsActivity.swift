//
//  FriendsActivity.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit
import AVFoundation

class FriendsActivity: UITableViewController {
    
    var noPostPic: UIImageView!
    var timer: NSTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YayMgr.FrPosts.observe { e in
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hidePostPic", userInfo: nil, repeats: false)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func hidePostPic() {
        noPostPic.hidden = (YayMgr.FrPosts.count > 0) ? true : false
        timer.invalidate()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let btn = cell.contentView.viewWithTag(20) as! UIButton
        btn.addTarget(self, action: "pointClick:", forControlEvents: .TouchUpInside)
        return populateFriendPost(indexPath.row,isMyActivity: false, cell: cell)
    }
    
    func pointClick(sender: UIButton){
       playSound(YayMgr.FrPosts[Int(sender.accessibilityValue!)!].Text.Yay)
       YayMgr.addPoint(Int(sender.accessibilityValue!)!)
    }
    
   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YayMgr.FrPosts.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFriendsActivityDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! ContainerController)
                controller.MyActivity = false;
                controller.detailItemIndex = indexPath.row
                controller.circleColor = YayMgr.FrPosts[indexPath.row].Text.Yay ? UIColor.Yay() : UIColor.Boo()
            }
        }
    }
}
