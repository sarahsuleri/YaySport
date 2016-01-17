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
    
    var userData:AnyObject?
    var userFriends:AnyObject?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loginView.delegate = self
        loginView.readPermissions = ["public_profile", "email", "user_friends"]

    }

    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                //print("fetched user: \(result)")
                self.saveInDB(result)
                //let userName = result.valueForKey("name") as? String
                //print("User Name is: \(userName)")
                self.userData = result
            }
        })
    }
    
    func returnUserFriends()
    {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error == nil {
                //print("Friends are : \(result)")
                self.userFriends = result
                
            } else {
                
                print("Error Getting Friends \(error)");
                
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
    
    
    
    // MARK: - Firebase Save User Data
    
    func saveInDB(data: AnyObject!) {
        let id = data.valueForKey("id") as! String
        let firstName = data.valueForKey("first_name") as! String
        let lastName = data.valueForKey("last_name") as! String
        let photoUrl = data.valueForKey("picture")!.valueForKey("data")!.valueForKey("url") as! String
        YayMgr.userID = Int(id)!
        
        let usersRef = firebase.childByAppendingPath("users/\(id)")
        usersRef.setValue([
            "FirstName": firstName,
            "LastName": lastName,
            "PhotoUrl": photoUrl
        ])
    }
    


}
