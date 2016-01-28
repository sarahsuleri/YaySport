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
    static var BooMsg = ObservableCollection([Message]())
    static var YayMsg = ObservableCollection([Message]())
    static var owner : User = User(Id: 0, FirstName: "temp", LastName: "temp", PhotoUrl: "temp")
    static var loaded : Bool = false
    
    var healthManager:HealthManager?
    var floors,steps, distanceWalked:HKQuantitySample?
    
    
    // MARK: - Firebase: load from DB
    
    static func load() {
        loadDefaults()
        if(loaded == false && owner.Id != 0) {
            loaded = true
            
            DBMgr.getMessages()
            DBMgr.getPostByPosterID(owner.Id)
            
            for friend in friendsIDs {
                DBMgr.getPostByPosterID(friend,isMyActivity: false);
            }
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
    
    
    
    static func getBooMsg() -> String {
        var randomIndex: UInt32!
        YayMsg.observe { e in
            randomIndex = arc4random_uniform(UInt32(YayMgr.BooMsg.count))
        }
        if randomIndex != nil {
            return YayMgr.BooMsg[Int(randomIndex)].Description
        } else {
            return ""
        }
    }
    
    static func getYayMsg() -> String {
        var randomIndex: UInt32!
        YayMsg.observe { e in
            randomIndex = arc4random_uniform(UInt32(YayMgr.YayMsg.count))
        }
        if randomIndex != nil {
            return YayMgr.YayMsg[Int(randomIndex)].Description
        } else {
            return ""
        }
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
        var msgObj :Message = Message(Title: dailyCount.description + " Steps!! ",Description: msgDesc, Yay: isYay)
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