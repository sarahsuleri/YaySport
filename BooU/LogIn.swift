//
//  LogIn.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class LogIn: UIViewController, FBSDKLoginButtonDelegate {
   
    @IBOutlet weak var loginView: FBSDKLoginButton!
    
    /*
    * Specifying the required permissions for the facebook
    */

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        loginView.readPermissions = ["public_profile", "user_friends"]
    }
    
    /*
    * Getting user information (id, name and picture from fb) and use them in the app
    */
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let userID = Int(result.valueForKey("id") as! String)!
                let fname =  result.valueForKey("first_name") as! String
                let lastName = result.valueForKey("last_name") as! String
                let photo = result.valueForKey("picture")!.valueForKey("data")!.valueForKey("url") as! String
                YayMgr.setOwner(User(Id: userID, FirstName: fname, LastName: lastName, PhotoUrl: photo))
                YayMgr.setSettings(SettingsDef())

            }
        }
    }
    
    /*
    * Getting list of user friends who installed the app from fb
    */
    func returnUserFriends()
    {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil
            {
              print("Error Getting Friends \(error)")
                
            } else
            {

                let friendsData = result as! NSDictionary
                var FrList = [Int]()
                for friend in friendsData.valueForKey("data") as! NSArray {
                    FrList.append(Int(friend.valueForKey("id") as! String)!)
                }
                YayMgr.setFriendList(FrList)
            }
        }
    }
    
    // Facebook Delegate Methods
    
    /*
    * Once login is successful update user info then go to the Tab bar controller in storyboard
    */
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        

        if ((error) != nil)
        {
            // Process error
             print("Error: \(error)")
        }
        else if result.isCancelled {
            // Handle cancellations
            print("login was cancelled by the user")
        }
        else {
            
            self.returnUserData()
            self.returnUserFriends()
            
            
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
         

        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
