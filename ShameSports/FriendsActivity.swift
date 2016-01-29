//
//  FriendsActivity.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class FriendsActivity: UITableViewController {
    

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
        let object = YayMgr.FrPosts[indexPath.row]
        
        return populateFriendPost(object,cell: cell)
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
                let controller = (segue.destinationViewController as! PostDetailController)
                controller.MyActivity = false;
                controller.detailItemIndex = indexPath.row
            }
        }
    }

    @IBAction func logOut(sender: UIBarButtonItem) {
        FBSDKLoginManager().logOut()
    //    FBSDKAccessToken.setCurrentAccessToken(nil)
    //    FBSDKProfile.setCurrentProfile(nil)
        YayMgr.myPosts.removeAll()
        YayMgr.FrPosts.removeAll()
        performSegueWithIdentifier("GoLogin", sender: nil)
    }
}

