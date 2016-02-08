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
    var timer: NSTimer!             // timer to wait: if loading posts OR there're no posts?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // FrPosts is an observable collection
        YayMgr.FrPosts.observe { e in
            // Fire timer in 2 sec. Supposedly, all data will be loaded
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "hidePostPic", userInfo: nil, repeats: false)
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        YayMgr.FrPosts.observe { e in
            self.tableView.reloadData()
        }
    }
    
    // If there was no data, then show "no posts" picture
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
    
    // +1 Yay or +1 Boo
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
    
    // Show Friends Activity = Show Comments to Friends' post
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowFriendsActivityDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! ContainerController)
                // Pass necessary parameters to Container Controller
                controller.MyActivity = false;
                controller.detailItemIndex = indexPath.row
                controller.circleColor = YayMgr.FrPosts[indexPath.row].Text.Yay ? UIColor.Yay() : UIColor.Boo()
            }
        }
    }
}
