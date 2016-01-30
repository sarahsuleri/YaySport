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
        YayMgr.myPosts.observe { e in
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        //let post : Post = Post(Poster: YayMgr.owner, Points: [], Comments: [], Text: m1, Timestamp: NSDate().timeIntervalSince1970)
        //DBMgr.addPost(post)
        //print("=================")
        if (YayMgr.myPosts.count != 0) {
            //print(Yay)
            //DBMgr.addComment(Comment(Commentor: YayMgr.owner, Comment: "Olalala", Timestamp: NSDate().timeIntervalSince1970), post: YayMgr.myPosts[0])
        }
        //print(YayMgr.BooMsg.count)
        print("get message: ", YayMgr.getYayMsg())
        print("get bad one: ", YayMgr.getBooMsg())
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        return populateMyPost(indexPath.row,isMyActivity: true,cell: cell)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return YayMgr.myPosts.count
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowMyActivityDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = (segue.destinationViewController as! ContainerController)
                controller.MyActivity = true;
                controller.detailItemIndex = indexPath.row

            }
        }
    }
}
