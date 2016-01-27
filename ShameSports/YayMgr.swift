//
//  YayMgr.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import HealthKit

class YayMgr {
    
    // Firebase-related variables
    
    static var firebase: Firebase = {
        let firebase = Firebase(url: "https://yaysport.firebaseio.com")
        return firebase
    }()
    static var postsRef, userRef, messageRef, commentsRef: Firebase!
    static var refs = [Firebase!]()
    
    static var userID = 0
    static var friendsIDs : [Int] = []
    //static var limitQueryTo : UInt = 50
    static var myPosts : [Post] = []
    static var FrPosts : [Post] = []
    static var BooMsg : [Message] = []
    static var YayMsg : [Message] = []
    //static var loaded : Bool = false
    
    var healthManager:HealthManager?
    var floors,steps, distanceWalked:HKQuantitySample?
    
    
    // MARK: - Firebase: load from DB
    
    static func load() {
        // this to be changed to  load from firebase
        //loaded = true
        //myPosts = loadPostsFromDB()
        //FrPosts = DummyD.getFrPost()
        //loadFriendsPosts()
        //loadMyPosts()
        //YayMsg.append(m0)
        //YayMsg.append(m2)
        //BooMsg.append(m1)
        //BooMsg.append(m3)
    }
    
    
    /*
    static func loadMyPosts() {
        myPosts.removeAll()
        loadPostByUserID(userID)
    }
    
    
    static func loadFriendsPosts() {
        FrPosts.removeAll()
        let postsRef = firebase.childByAppendingPath("posts")
        postsRef.queryLimitedToLast(limitQueryTo).observeEventType(.ChildAdded, withBlock: { snapshot in
            if friendsIDs.contains(snapshot.value["Poster"] as! Int) {
                //print("Load Post from ", snapshot.value["Poster"] as! Int)
                loadPost(snapshot, tag: "friends")
            }
        })
    }
    */
    
    static func loadPostByUserID(id: Int) {
        postsRef = firebase.childByAppendingPath("posts")
        postsRef.queryOrderedByChild("Poster").queryEqualToValue(id).observeEventType(.ChildAdded, withBlock: { snapshot in
            //loadPost(snapshot, tag: "my")
        })
        refs.append(postsRef)
    }
    
    
    static func loadPost(snapshot: FDataSnapshot, tag: String, completionHandler: (Post) -> ()) {
        
        // Get Poster ID
        let posterID = snapshot.value["Poster"] as! Int
        
        // Get Points
        let points = snapshot.value["Points"] as! [Int]
        
        // Get Timestamp
        let timestamp = snapshot.value["Timestamp"] as! Double
        
        // Get Post Owner
        getUserByID(posterID) { poster in
            
            // Get Message
            let textDict = snapshot.value["Text"] as! NSDictionary
            let title = textDict.valueForKey("Title") as! String
            let messageID = textDict.valueForKey("Message") as! Int
            getMessageByID(messageID, title: title) { text in
                
                // Get Comments
                loadComments(Int(snapshot.key)!) { comments in
                    
                    // Create a Post
                    let post = Post(Poster: poster, Points: points, Comments: comments, Text: text, Timestamp: timestamp)
                    
                    if tag == "friends" {
                        FrPosts.insert(post, atIndex: 0)
                    } else {
                        myPosts.insert(post, atIndex: 0)
                    }
                    print("FrPosts size: ", FrPosts.count)
                    completionHandler(post)
                }
            }
        }
    }
    
    
    static func getUserByID(id: Int, completionHandler: (User) -> ()) {
        userRef = firebase.childByAppendingPath("users/\(id)")
        userRef.observeEventType(.Value, withBlock: {
            snapshot in
            let user = User(Id: id,
                FirstName: snapshot.value["FirstName"] as! String,
                LastName: snapshot.value["LastName"] as! String,
                PhotoUrl: snapshot.value["PhotoUrl"] as! String
            )
            completionHandler(user)
        })
        refs.append(userRef)
    }
    
    
    static func getMessageByID(id: Int, title: String, completionHandler: (Message) -> ()) {
        messageRef = firebase.childByAppendingPath("messages/\(id)")
        messageRef.observeEventType(.Value, withBlock: {
            snapshot in
            let message = Message(Id: id,
                Title: title,
                Description: snapshot.value["Description"] as! String,
                Yay: snapshot.value["Yay"] as! Bool
            )
            completionHandler(message)
        })
        refs.append(messageRef)
    }
    
    
    static func loadComments(postId: Int, completionHandler: ([Comment]) -> ()) {
        var comments = [Comment]()
        commentsRef = firebase.childByAppendingPath("comments")
        
        commentsRef.queryOrderedByChild("PostID").queryEqualToValue(postId).observeEventType(.Value, withBlock: { snapshot in
            
            let loadCommentorGroup = dispatch_group_create()
            let enumerator = snapshot.children
            while let snapChild = enumerator.nextObject() as? FDataSnapshot {
                dispatch_group_enter(loadCommentorGroup)
                getUserByID(snapChild.value!["Commentor"] as! Int) { commentor in
                    let comment = Comment(Commentor: commentor,
                        Comment: snapChild.value!["Comment"] as! String)
                    comments.append(comment)
                    dispatch_group_leave(loadCommentorGroup)
                }
            }
            dispatch_group_notify(loadCommentorGroup, dispatch_get_main_queue()) {
                completionHandler(comments)
            }
        })
        refs.append(commentsRef)
    }
    
    
    // MARK: - Firebase: save data to DB
    
    static func saveUserInDB(userData: AnyObject!) {
        YayMgr.userID = Int(userData.valueForKey("id") as! String)!
        userRef = firebase.childByAppendingPath("users/\(YayMgr.userID)")
        userRef.setValue([
            "FirstName": userData.valueForKey("first_name") as! String,
            "LastName": userData.valueForKey("last_name") as! String,
            "PhotoUrl": userData.valueForKey("picture")!.valueForKey("data")!.valueForKey("url") as! String
        ])
    }
    
    static func savePostInDB(post: Post) {
        postsRef = firebase.childByAppendingPath("posts").childByAutoId()
        postsRef.setValue([
            "Comments": [],
            "Points": [],
            "Poster": post.Poster.Id,
            "Text": ["Message": post.Text.Id, "Title": post.Text.Title],
            "Timestamp": NSDate().timeIntervalSince1970
        ])
    }
    
    static func saveFriendsIDs(friendsData: NSDictionary!) {
        userRef = firebase.childByAppendingPath("users/\(YayMgr.userID)")
        for friend in friendsData.valueForKey("data") as! NSArray {
            YayMgr.friendsIDs.append(Int(friend.valueForKey("id") as! String)!)
        }
        userRef.updateChildValues([ "FriendsIDs": YayMgr.friendsIDs ])
    }
    
    
    static func createPost(message: Message, completionHandler: Post -> ()) {
        var newPost: Post!
        getUserByID(userID) { currentUser in
            print("current user: ", currentUser.FirstName, " ", currentUser.LastName)
            newPost = Post(Poster: currentUser, Points: [], Comments: [], Text: message, Timestamp: NSDate().timeIntervalSince1970)
            savePostInDB(newPost)
            completionHandler(newPost)
        }
    }
    
    static func getBooMsg() -> String{
        let randomIndex = arc4random_uniform(UInt32(YayMgr.BooMsg.count))
        return YayMgr.BooMsg[Int(randomIndex)].Description
    }
    
    static func getYayMsg() -> String{
         let randomIndex = arc4random_uniform(UInt32(YayMgr.YayMsg.count))
        return YayMgr.YayMsg[Int(randomIndex)].Description
    }
    
    // Criteria to show msgs
    static func criteriaToShowMsg(dailyCount: Int, isStep:Bool , isFloor: Bool){
    
        var msgDesc : String = ""
        var isYay: Bool = true
       

        if isStep {
        if( dailyCount < 200){
            dispatch_async(dispatch_get_main_queue(), {
                msgDesc = YayMgr.getBooMsg()
                isYay = false
                YayMgr.registerNotification(dailyCount.description + " Steps!! " + msgDesc)
            })
        }
        else if( dailyCount >= 200){
            dispatch_async(dispatch_get_main_queue(), {
                msgDesc = YayMgr.getYayMsg()
                isYay = true
                YayMgr.registerNotification(dailyCount.description + " Steps!! " + msgDesc)
            })
        }
        
        
        
        // Msg object
        var msgObj :Message = Message(Id: 0,Title: dailyCount.description + " Steps!! ",Description: msgDesc, Yay: isYay)
        }
        else if isFloor {
            //Criteria for floors
        }
    
    }
    
    // Register Notifications : To be altered for different msgs
    static func registerNotification(msg : String){
        
    //Register Notifications
    let gCalender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    let day =  gCalender.components(NSCalendarUnit.Day , fromDate: NSDate())
    let month =  gCalender.components(NSCalendarUnit.Month , fromDate: NSDate())
    let year =  gCalender.components(NSCalendarUnit.Year , fromDate: NSDate())
    let hour = gCalender.components(NSCalendarUnit.Hour , fromDate: NSDate())
    let min = gCalender.components(NSCalendarUnit.Minute , fromDate: NSDate())
    
    let dateComp:NSDateComponents = NSDateComponents()
    dateComp.year = year.year
    dateComp.month = month.month
    dateComp.day =   day.day
    dateComp.hour = hour.hour
    print(hour.hour.description)
    print(min.minute.advancedBy(1).description)
    dateComp.minute = min.minute.advancedBy(1)
    dateComp.timeZone = NSTimeZone.systemTimeZone()
    
    
    let fireDate:NSDate = gCalender.dateFromComponents(dateComp)!
    
    
    let notification:UILocalNotification = UILocalNotification()
    //notification.alertTitle = "200 Steps"
    notification.alertBody = msg
    notification.fireDate = fireDate
    
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
        
    }
    // HK : Load Data : Sample Queries for testing 
    
    func readSteps(){
        
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        self.healthManager?.readMostRecentSample(sampleType!, completion: { (mostRecentSteps, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading steps taken from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
            self.steps = mostRecentSteps.first as? HKQuantitySample;
            var dailyAVG:Double = 0
            for _steps in mostRecentSteps as! [HKQuantitySample]
            {
                dailyAVG += _steps.quantity.doubleValueForUnit(HKUnit.countUnit())
            }
            print(dailyAVG)
            
        });
    }
    
    func readFloors(){
        
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed)
        
        self.healthManager?.readMostRecentSample(sampleType!, completion: { (mostRecentFloors, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading number of floors climbed from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
            self.floors = mostRecentFloors.first as? HKQuantitySample;
            var dailyAVG:Double = 0
            for _floors in mostRecentFloors as! [HKQuantitySample]
            {
                dailyAVG += _floors.quantity.doubleValueForUnit(HKUnit.countUnit())
            }
            print(dailyAVG)
            
            
            
        });
    }
    
    func readDistanceWalked(){
        
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)
        self.healthManager?.readMostRecentSample(sampleType!, completion: { (mostRecentDistance, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading distance walked from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
            self.distanceWalked = mostRecentDistance.first as? HKQuantitySample;
            
            var dailyAVG:Double = 0
            for _distance in mostRecentDistance as! [HKQuantitySample]
            {
                dailyAVG += _distance.quantity.doubleValueForUnit(HKUnit.mileUnit())
            }
            print(dailyAVG)
            
            
        });
    }
}