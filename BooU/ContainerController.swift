//
//  ContainerController.swift
//  BooU
//
//  Created by Daria on 30.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    // Need for container view was caused by the impossibility
    // to add any additional UI element to the
    // Table View Controller
    
    var MyActivity: Bool!                           // my posts or friends' posts
    var detailItemIndex: Int!                       // index of the post
    var circleColor: UIColor!                       // Yay or Boo color for "+" button
    @IBOutlet weak var noComPic: UIImageView!       // noCom or noPost image
    @IBOutlet weak var circleButton: CircleButton!  // "+" button

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if circleButton != nil {
            circleButton.fillColor = circleColor
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If want to show comments, pass necessary items
        if segue.identifier == "ShowComments" {
            let controller = segue.destinationViewController as! PostDetailController
            controller.MyActivity = MyActivity
            controller.detailItemIndex = detailItemIndex
            controller.noComPic = noComPic  // in case there are no comments to the post
        }
        // If want to show friends' posts and there are no posts yet
        if segue.identifier == "showFriendsPosts" {
            let controller = segue.destinationViewController as! FriendsActivity
            controller.noPostPic = noComPic
        }
    }
}
