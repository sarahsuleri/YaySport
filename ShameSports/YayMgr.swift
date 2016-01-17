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
    static var myPosts : [Post] = []
    static var FrPosts : [Post] = []
    static var BooMsg : [Message] = []
    static var YayMsg : [Message] = []
    static var loaded : Bool = false
    
    var healthManager:HealthManager?
    var floors,steps, distanceWalked:HKQuantitySample?
    
    static func load() {
        
        // this to be changed to  load from firebase
        loaded = true
        myPosts = DummyD.getMyPost()
        FrPosts = DummyD.getFrPost()
        YayMsg.append(m0)
        YayMsg.append(m2)
        BooMsg.append(m1)
        BooMsg.append(m3)
        

        
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
    static func criteriaToShowMsg(dailyCount: Int){
    
        YayMgr.load() //Just for testing
        if( dailyCount < 200){
            dispatch_async(dispatch_get_main_queue(), {
                
                YayMgr.registerNotification(dailyCount.description + " Steps!! " + YayMgr.getBooMsg())
            })
        }
        else if( dailyCount >= 200){
            dispatch_async(dispatch_get_main_queue(), {
                
                YayMgr.registerNotification(dailyCount.description + " Steps!! " + YayMgr.getYayMsg())
            })
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