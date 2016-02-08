//
//  MyActivity.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class MyActivity: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // myPosts is an observable collection
        YayMgr.myPosts.observe { e in
            self.tableView.reloadData()
        }
    }
    
    /*
    * With every device rotation redraw the charts in the first cell for the row (spacing between
    * charts differ according to screen width)
    */
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        YayMgr.myPosts.observe { e in
            self.tableView.reloadData()
        }
}
    
    /*
    * Add the contents of Header Cell in the first cell of the table, others are posts
    */

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
            cell.createViews()
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            return populateMyPost(indexPath.row, isMyActivity: true,cell: cell)
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return YayMgr.myPosts.count
    }
    
    // Show My Activity = Show Comments to owner's posts
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMyActivityDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! ContainerController)
                controller.MyActivity = true
                controller.detailItemIndex = indexPath.row
                controller.circleColor = YayMgr.myPosts[indexPath.row].Text.Yay ? UIColor.Yay() : UIColor.Boo()
            }
        }
    }
}
