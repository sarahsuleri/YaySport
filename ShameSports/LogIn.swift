//
//  LogIn.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class LogIn: UIViewController, FBSDKLoginButtonDelegate {
    
    private lazy var firebase: Firebase =  {
        let firebase = Firebase(url: "https://yaysport.firebaseio.com")
        return firebase
    }()
    
   
    @IBOutlet weak var loginView: FBSDKLoginButton!
    
    //var userData: AnyObject?
    //var userFriends: AnyObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        loginView.readPermissions = ["public_profile", "user_friends"]
    }
    
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
                
                YayMgr.owner = User(Id: userID, FirstName: fname, LastName: lastName, PhotoUrl: photo)
                

            }
        }
    }
    
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
                
                for friend in friendsData.valueForKey("data") as! NSArray {
                    YayMgr.friendsIDs.append(Int(friend.valueForKey("id") as! String)!)
                }

                
            }
        }
    }
    // Facebook Delegate Methods
    
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
        print("User Logged Out")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
