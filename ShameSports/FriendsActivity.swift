//
//  FriendsActivity.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 10/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class FriendsActivity: UITableViewController {
    
    lazy var firebase: Firebase = {
        let firebase = Firebase(url: "https://yaysport.firebaseio.com")
        return firebase
    }()
    var postsRef: Firebase!
    var postsHandle: UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //YayMgr.load()
        self.tableView.reloadData()
    }
    
    static var fCell : UITableViewCell?
    
    override func viewWillAppear(animated: Bool) {
        print("Friends View will appear")
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        // Test: Create a Post
        /*
        YayMgr.createPost(Message(Id: 0, Title: "Blabla", Description: "Blabla", Yay: false)) { newPost in
            print("New post: ", newPost)
        }
        */
        
        // Loading latest posts from friends
        //YayMgr.FrPosts.removeAll()
        postsRef = firebase.childByAppendingPath("posts")
        postsHandle = postsRef.queryLimitedToLast(50).observeEventType(.ChildAdded, withBlock: { snapshot in
            if YayMgr.friendsIDs.contains(snapshot.value["Poster"] as! Int) {
                YayMgr.loadPost(snapshot, tag: "friends") { _ in
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        postsRef.removeObserverWithHandle(postsHandle)
        for refDescription in Array(YayMgr.refs) {
            refDescription.removeAllObservers()
        }
        YayMgr.refs.removeAll()
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
                let object = YayMgr.FrPosts[indexPath.row]
                let controller = (segue.destinationViewController as! PostDetailController)
                controller.MyActivity = true;
                controller.detailItem = object
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

