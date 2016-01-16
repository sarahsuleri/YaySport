//
//  LogIn.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import UIKit

class LogIn: UIViewController,FBSDKLoginButtonDelegate{
    
   
    @IBOutlet weak var loginView: FBSDKLoginButton!
    
    var userData:AnyObject?
    var userFriends:AnyObject?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        loginView.delegate = self
        loginView.readPermissions = ["public_profile", "user_friends"]
        
        
        //Register Notifications
        let gCalender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let day =  gCalender.components(NSCalendarUnit.Day , fromDate: NSDate())
        let month =  gCalender.components(NSCalendarUnit.Month , fromDate: NSDate())
        let year =  gCalender.components(NSCalendarUnit.Year , fromDate: NSDate())

        
        let dateComp:NSDateComponents = NSDateComponents()
        dateComp.year = year.year
        dateComp.month = month.month
        dateComp.day =   day.day
        dateComp.hour = 18
        dateComp.minute = 45
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        
       
        let fireDate:NSDate = gCalender.dateFromComponents(dateComp)!
        
        
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = "Hi, I am a notification"
        notification.fireDate = fireDate
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }

    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"])
        graphRequest.startWithCompletionHandler{ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                let userName = result.valueForKey("name") as? String
                print("User Name is: \(userName)")
                self.userData = result
            }
        }
    }
    
    func returnUserFriends()
    {
        let fbRequest = FBSDKGraphRequest(graphPath:"/me/friends", parameters: ["fields": "id, name, first_name, last_name, picture.type(large)"]);
        fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            
            if error != nil
            {
                
              print("Error Getting Friends \(error)");
                
            } else
            {
                
                print("Friends are : \(result)")
                self.userFriends = result
                
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
