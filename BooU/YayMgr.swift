//
//  YayMgr.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import HealthKit
import ReactiveFoundation
import ReactiveKit


class YayMgr {
    
    static var friendsIDs : [Int] = []
    static var myPosts = ObservableCollection([Post]())
    static var FrPosts = ObservableCollection([Post]())
    static var BooMsg : [Message] = []
    static var YayMsg : [Message] = []
    static var owner : User = User(Id: 0, FirstName: "temp", LastName: "temp", PhotoUrl: "temp")
    static var loaded : Bool = false
    static var userSettings: SettingsDef = SettingsDef()
    static let booSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("boo", ofType: "mp3")!)
    static let yaySound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("yay", ofType: "mp3")!)
    
    
    // MARK: - Firebase: load from DB
    
    static func load() {
        loadDefaults()
        print("owner id: ", owner.Id, " loaded: ", loaded)
        if(loaded == false && owner.Id != 0) {
            loaded = true
            
            DBMgr.getMessages()
            DBMgr.getPostByPosterID(owner.Id)
            
            for friend in friendsIDs {
                DBMgr.getPostByPosterID(friend,isMyActivity: false);
            }
            
            
            dispatch_async(dispatch_get_main_queue(),{
                HealthManager.startObservingStepsChanges()
                
                HealthManager.startObservingFloorsChanges()
                
                HealthManager.startObservingMilesChanges()
            })
            
            
        }
    }
    
    static func setOwner(user: User) {
        YayMgr.owner = user
        saveDefaults()
        //load()
    }
    
    static func setFriendList(frList: [Int]) {
        YayMgr.friendsIDs = frList
        saveDefaults()
        load()
    }
    
    static func setSettings(settings:SettingsDef){
        YayMgr.userSettings = settings
        saveDefaults()
    }
    
    
    static func getBooMsg() -> String{
        if YayMgr.BooMsg.count == 0{
            return "Seriously! Even snails move more than you !"
        }
        let randomIndex = arc4random_uniform(UInt32(YayMgr.BooMsg.count))
        return YayMgr.BooMsg[Int(randomIndex)].Description
    }
    
    static func getYayMsg() -> String{
        if YayMgr.YayMsg.count == 0{
            return "Job Well Done !"
        }
        let randomIndex = arc4random_uniform(UInt32(YayMgr.YayMsg.count))
        return YayMgr.YayMsg[Int(randomIndex)].Description
    }
    
    
    static func addPoint(index : Int) {
        //YayMgr.FrPosts[index].Points.append(owner.Id)
        DBMgr.addPoint(YayMgr.FrPosts[index])
    }
    
    static func addComment(comment: Comment, index : Int, isMyactivity : Bool) {
        //myPosts[index].Comments.append(comment)
        isMyactivity ? DBMgr.addComment(comment, post: myPosts[index]) : DBMgr.addComment(comment, post: FrPosts[index])
    }
    
    static func addPost(msgObj : Message){
        DBMgr.addPost(Post(Poster: owner, Points: [1], Comments: [], Text: msgObj, Timestamp: NSDate().timeIntervalSince1970))
    }
    
    static func saveDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(owner.Id, forKey: "Id")
        defaults.setObject(owner.FirstName, forKey: "FirstName")
        defaults.setObject(owner.LastName, forKey: "LastName")
        defaults.setObject(owner.PhotoUrl, forKey: "PhotoUrl")
        defaults.setObject(friendsIDs, forKey: "frlist")
        defaults.setInteger(userSettings.minSteps, forKey: "minSteps")
        defaults.setInteger(userSettings.maxSteps, forKey: "maxSteps")
        defaults.setInteger(userSettings.minMiles, forKey: "minMiles")
        defaults.setInteger(userSettings.maxMiles, forKey: "maxMiles")
        defaults.setInteger(userSettings.minFloors, forKey: "minFloors")
        defaults.setInteger(userSettings.maxFloors, forKey: "maxFloors")
    }
    
    static func loadDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let Id = defaults.integerForKey("Id")
        let FirstName = defaults.stringForKey("FirstName")
        let LastName = defaults.stringForKey("LastName")
        let PhotoUrl = defaults.stringForKey("PhotoUrl")
        let frlist = defaults.arrayForKey("frlist")
        let minStep = defaults.integerForKey("minSteps")
        let maxStep = defaults.integerForKey("maxSteps")
        let minMile = defaults.integerForKey("minMiles")
        let maxMile = defaults.integerForKey("maxMiles")
        let minFloor = defaults.integerForKey("minFloors")
        let maxFloors = defaults.integerForKey("maxFloors")
        
        if (Id != 0) {
            owner = User(Id: Id, FirstName: FirstName!, LastName: LastName!, PhotoUrl: PhotoUrl!)
            friendsIDs = frlist as! [Int]
            self.userSettings = SettingsDef(minStep: minStep, maxStep: maxStep, minMile: minMile, maxMile: maxMile, minFloor: minFloor, maxFloor: maxFloors)
        }
        
    }
    
    static func logOut() {
        
        loaded = false
        DBMgr.removeAllObservers()
        
        myPosts.removeAll(); FrPosts.removeAll()
        YayMsg.removeAll(); BooMsg.removeAll()
        
        friendsIDs.removeAll()
        
//        HealthManager.stopObservingFloorsChanges()
//        HealthManager.stopObservingMilesChanges()
//        HealthManager.stopObservingStepsChanges()
    }
}