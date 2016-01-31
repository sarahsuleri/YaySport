//
//  FriendsActivity.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit
import AVFoundation

class FriendsActivity: UITableViewController {

    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        YayMgr.FrPosts.observe { e in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
    
    func playSound(isYay: Bool){
        if isYay {
            try! audioPlayer = AVAudioPlayer(contentsOfURL: YayMgr.yaySound)
            
        }
        else
        {
            try! audioPlayer = AVAudioPlayer(contentsOfURL: YayMgr.booSound)
        }
        audioPlayer.play()
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

