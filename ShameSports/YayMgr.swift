//
//  YayMgr.swift
//  ShameSports
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
    
    
    // MARK: - Firebase: load from DB
    
    static func load() {
        loadDefaults()
        if(loaded == false && owner.Id != 0){
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
    
    
    
    
    static func saveDefaults(){
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(owner.Id, forKey: "Id")
        defaults.setObject(owner.FirstName, forKey: "FirstName")
        defaults.setObject(owner.LastName, forKey: "LastName")
        defaults.setObject(owner.PhotoUrl, forKey: "PhotoUrl")
        defaults.setObject(friendsIDs, forKey: "frlist")
    }
    
    static func loadDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        let Id = defaults.integerForKey("Id")
        let FirstName = defaults.stringForKey("FirstName")
        let LastName = defaults.stringForKey("LastName")
        let PhotoUrl = defaults.stringForKey("PhotoUrl")
        let frlist = defaults.arrayForKey("frlist")
        
        if (Id != 0) {
            owner = User(Id: Id, FirstName: FirstName!, LastName: LastName!, PhotoUrl: PhotoUrl!)
            friendsIDs = frlist as! [Int]
        }
        
    }
}