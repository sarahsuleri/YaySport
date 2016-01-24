//
//  TabBarViewController.swift
//  ShameSports
//
//  Created by Daria on 24.01.16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    lazy var firebase: Firebase = {
        let firebase = Firebase(url: "https://yaysport.firebaseio.com")
        return firebase
    }()
    
    var messagesRef: Firebase!
    var messagesHandle: UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesRef = firebase.childByAppendingPath("messages")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        messagesHandle = messagesRef.observeEventType(.Value, withBlock: {
            snapshot in
            let enumerator = snapshot.children
            while let snapChild = enumerator.nextObject() as? FDataSnapshot {
                let message = Message(Id: Int(snapChild.key)!,
                    Title: "",
                    Description: snapChild.value["Description"] as! String,
                    Yay: snapChild.value["Yay"] as! Bool
                )
                message.Yay ? YayMgr.YayMsg.append(message) : YayMgr.BooMsg.append(message)
            }
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Remove listener with handle
        messagesRef.removeObserverWithHandle(messagesHandle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
