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
        testFirebase.getPostByPosterID(23156)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = testFirebase.myPosts[indexPath.row]
        return populateMyPost(object,cell: cell)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return testFirebase.myPosts.count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMyActivityDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = testFirebase.myPosts[indexPath.row]
                let controller = (segue.destinationViewController as! PostDetailController)
                controller.MyActivity = true;
                controller.detailItem = object

            }
        }
    }


}
