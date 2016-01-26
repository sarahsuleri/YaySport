//
//  PostDetailController.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 26/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class PostDetailController: UITableViewController {
    var MyActivity = true;
    var detailItem: Post! {
        didSet {
            // Update the view.
            self.tableView.reloadData();
        }
    }
    override func viewDidLoad() {

        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        print(detailItem.DBIndex)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell!
        if(indexPath.row == 0){
            if(MyActivity == true){
                cell = tableView.dequeueReusableCellWithIdentifier("mPost", forIndexPath: indexPath) as UITableViewCell
                let title = cell.contentView.viewWithTag(10) as! UILabel
                title.text = detailItem.Text.Title
            }
            else {
                 cell = tableView.dequeueReusableCellWithIdentifier("fPost", forIndexPath: indexPath) as UITableViewCell
                let title = cell.contentView.viewWithTag(10) as! UILabel
                title.text = detailItem.Text.Title
            }
        }
        else{
             cell = tableView.dequeueReusableCellWithIdentifier("comment", forIndexPath: indexPath) as UITableViewCell
            let title = cell.contentView.viewWithTag(10) as! UILabel
            title.text = detailItem.Comments[indexPath.row-1].Comment
        }


        return cell
    } 
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (detailItem.Comments.count+1)
    }
}
