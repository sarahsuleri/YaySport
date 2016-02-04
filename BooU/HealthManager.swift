//
//  HealthManager.swift
//  BooU
//
//  Created by Sarah Suleri on 16/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import HealthKit
import AudioToolbox



class HealthManager {
    
    static var msgObj :Message = Message(Title: "",Description: "",Yay: false)
    
    static var healthKitStore:HKHealthStore = {
    /*  if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }*/
        return HKHealthStore()
    }()
    
   static let objStepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
   static let objFlightsClimbed = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed)!
    static let objDistanceWalkedRunning = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
    
     static var lstSteps: [HKQuantitySample] = []
    
    //Query
    static var querySteps: HKObserverQuery = {
        return HKObserverQuery(sampleType: HealthManager.objStepsCount,
            predicate: HealthManager.predicate,
            updateHandler: HealthManager.stepsChangedHandler)
    }()
    
    static var queryFloors: HKObserverQuery = {
        return HKObserverQuery(sampleType: HealthManager.objFlightsClimbed,
            predicate: HealthManager.predicate,
            updateHandler: HealthManager.floorsChangedHandler)
    }()
    
    
    static var queryMiles: HKObserverQuery = {
        return HKObserverQuery(sampleType: HealthManager.objDistanceWalkedRunning,
            predicate: HealthManager.predicate,
            updateHandler: HealthManager.milesChangedHandler)
    }()

    //Predicate
    static var predicate: NSPredicate = {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let endDate = NSDate()
        let startDate = cal.startOfDayForDate(endDate)
        let now = NSDate()
        let yesterday =
        NSCalendar.currentCalendar().dateByAddingUnit(.Day,
            value: -1,
            toDate: now,
            options: .WrapComponents)
        
        return HKQuery.predicateForSamplesWithStartDate(startDate,
            endDate: endDate,
            options: .StrictEndDate)
    }()
    

    // Observer Query
    
    lazy var types: Set<HKObjectType> = {
        return [HealthManager.objStepsCount, HealthManager.objFlightsClimbed, HealthManager.objDistanceWalkedRunning]
    }()
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        let healthKitTypesToRead : NSSet = NSSet(set: [HealthManager.objStepsCount,HealthManager.objFlightsClimbed,HealthManager.objDistanceWalkedRunning ])
       

         HealthManager.healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) -> Void in
            
            if success && error == nil{
                } else {
                if let theError = error{
                    print("Error occurred = \(theError)")
                }
            }
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
    }
    
    
    //Fetch Calls
    static func fetchRecordedStepsISinceStartOfDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: HealthManager.objStepsCount,
            predicate: HealthManager.predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {(query: HKSampleQuery,
                results: [HKSample]?,
                error: NSError?) in
                
                guard let results = results where results.count > 0 else {
                    print("Could not read the user's steps")
                    print("or no steps data was available")
                    return
                }
                
                var dailyAVG:Int = 0
                for _steps in results as! [HKQuantitySample]
                {
                    dailyAVG += Int(_steps.quantity.doubleValueForUnit(HKUnit.countUnit()))
                }
                            
                //Criteria to show msg
                
                HealthManager.criteriaToShowMsg(dailyAVG,isStep: true,isFloor: false,isMiles: false)
                
        })
        
         HealthManager.healthKitStore.executeQuery(query)
        
    }
    
    static func fetchRecordedFloorsSinceStartOfDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: HealthManager.objFlightsClimbed,
            predicate: predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {(query: HKSampleQuery,
                results: [HKSample]?,
                error: NSError?) in
                
                guard let results = results where results.count > 0 else {
                    print("Could not read the user's floors")
                    print("or no floors data was available")
                    return
                }
                
                var dailyAVG:Int = 0
                for _floors in results as! [HKQuantitySample]
                {
                    dailyAVG += Int(_floors.quantity.doubleValueForUnit(HKUnit.countUnit()))
                }
                
                
                //Criteria to show msg
                
               HealthManager.criteriaToShowMsg(dailyAVG,isStep: false,isFloor: true,isMiles: false)
                
        })
        
         HealthManager.healthKitStore.executeQuery(query)
        
    }
    
    static func fetchRecordedMilesSinceStartOfDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: HealthManager.objDistanceWalkedRunning,
            predicate: HealthManager.predicate,
            limit: Int(HKObjectQueryNoLimit),
            sortDescriptors: [sortDescriptor],
            resultsHandler: {(query: HKSampleQuery,
                results: [HKSample]?,
                error: NSError?) in
                
                guard let results = results where results.count > 0 else {
                    print("Could not read the user's miles")
                    print("or no miles data was available")
                    return
                }
                
                var dailyAVG:Int = 0
                for _miles in results as! [HKQuantitySample]
                {
                    dailyAVG += Int(_miles.quantity.doubleValueForUnit(HKUnit.mileUnit()))
                }
                
                
                //Criteria to show msg
                
                HealthManager.criteriaToShowMsg(dailyAVG,isStep: false,isFloor: false,isMiles: true)
                
        })
        
         HealthManager.healthKitStore.executeQuery(query)
        
    }
    
    //Change Handler
    
    static func stepsChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedStepsISinceStartOfDay()
            
            completionHandler()
            
    }
    
    static func floorsChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedFloorsSinceStartOfDay()
            
            completionHandler()
            
    }
    
    static func milesChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedMilesSinceStartOfDay()
            
            completionHandler()
            
    }
    
    //Start Observation
     static func startObservingStepsChanges(){
        querySteps = {
            return HKObserverQuery(sampleType: HealthManager.objStepsCount,
                predicate: HealthManager.predicate,
                updateHandler: HealthManager.stepsChangedHandler)
        }()

         HealthManager.healthKitStore.executeQuery(HealthManager.querySteps)
         HealthManager.healthKitStore.enableBackgroundDeliveryForType(objStepsCount,
            frequency: .Daily,
            withCompletion: {succeeded, error in
                
                if succeeded{
                    print("Enabled background delivery of steps changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery of steps changes. ")
                        print("Error = \(theError)")
                    }
                }
                
        })
    }
    
    static func startObservingFloorsChanges(){
        queryFloors = {
            return HKObserverQuery(sampleType: HealthManager.objFlightsClimbed,
                predicate: HealthManager.predicate,
                updateHandler: HealthManager.floorsChangedHandler)
        }()

         HealthManager.healthKitStore.executeQuery(HealthManager.queryFloors)
         HealthManager.healthKitStore.enableBackgroundDeliveryForType(objFlightsClimbed,
            frequency: .Daily,
            withCompletion: {succeeded, error in
                
                if succeeded{
                    print("Enabled background delivery of floors changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery of floors changes. ")
                        print("Error = \(theError)")
                    }
                }
                
        })
    }
    static func startObservingMilesChanges(){
        queryMiles = {
            return HKObserverQuery(sampleType: HealthManager.objDistanceWalkedRunning,
                predicate: HealthManager.predicate,
                updateHandler: HealthManager.milesChangedHandler)
        }()

         HealthManager.healthKitStore.executeQuery(HealthManager.queryMiles)
         HealthManager.healthKitStore.enableBackgroundDeliveryForType(objDistanceWalkedRunning,
            frequency: .Daily,
            withCompletion: {succeeded, error in
                
                if succeeded{
                    print("Enabled background delivery of miles changes")
                } else {
                    if let theError = error{
                        print("Failed to enable background delivery of miles changes. ")
                        print("Error = \(theError)")
                    }
                }
                
        })
    }
    
   

    //Stop Observation
    static func stopObservingStepsChanges(){
        HealthManager.healthKitStore.stopQuery(HealthManager.querySteps)
         HealthManager.healthKitStore.disableAllBackgroundDeliveryWithCompletion{
            succeeded, error in
            
            if succeeded{
                print("Disabled background delivery of steps changes")
            } else {
                if let theError = error{
                    print("Failed to disable background delivery of steps changes. ")
                    print("Error = \(theError)")
                }
            }
            
        }
    }

    
    static func stopObservingFloorsChanges(){
         HealthManager.healthKitStore.stopQuery(HealthManager.queryFloors)
         HealthManager.healthKitStore.disableAllBackgroundDeliveryWithCompletion{
            succeeded, error in
            
            if succeeded{
                print("Disabled background delivery of floors changes")
            } else {
                if let theError = error{
                    print("Failed to disable background delivery of floors changes. ")
                    print("Error = \(theError)")
                }
            }
            
        }
    }
    
    static func stopObservingMilesChanges(){
         HealthManager.healthKitStore.stopQuery(HealthManager.queryMiles)
         HealthManager.healthKitStore.disableAllBackgroundDeliveryWithCompletion{
            succeeded, error in
            
            if succeeded{
                print("Disabled background delivery of miles changes")
            } else {
                if let theError = error{
                    print("Failed to disable background delivery of miles changes. ")
                    print("Error = \(theError)")
                }
            }
            
        }
    }

    
    
   

    // Criteria to show msgs<
    static func criteriaToShowMsg(dailyCount: Int, isStep:Bool , isFloor: Bool, isMiles: Bool){
        
        var msgDesc : String = ""
        var isYay: Bool = true
        
        if isStep {
            if( dailyCount < YayMgr.userSettings.minSteps){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getBooMsg()
                    isYay = false
                    self.registerNotification(dailyCount.description + " Steps!! " + msgDesc,Yay: isYay)
                    
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Steps!! ",Description: msgDesc, Yay: isYay)
                    
                    if YayMgr.loaded {
                        YayMgr.addPost(msgObj)
                    }
                })
            }
            else if( dailyCount >= YayMgr.userSettings.maxSteps){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getYayMsg()
                    isYay = true
                    self.registerNotification(dailyCount.description + " Steps!! " + msgDesc,Yay: isYay)
                    
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Steps!! ",Description: msgDesc, Yay: isYay)
                    
                    if YayMgr.loaded {
                        YayMgr.addPost(msgObj)
                    }
                })
            }
            
            
        }
        else if isFloor {
            //Criteria for floors
            
            if( dailyCount < YayMgr.userSettings.minFloors){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getBooMsg()
                    isYay = false
                    self.registerNotification(dailyCount.description + " Floors!! " + msgDesc,Yay: isYay)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Floors!! ",Description: msgDesc, Yay: isYay)
                    
                    if YayMgr.loaded {
                        YayMgr.addPost(msgObj)
                    }
                })
            }
            else if( dailyCount >= YayMgr.userSettings.maxFloors){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getYayMsg()
                    isYay = true
                    self.registerNotification(dailyCount.description + " Floors!! " + msgDesc,Yay: isYay)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Floors!! ",Description: msgDesc, Yay: isYay)
                    
                    if YayMgr.loaded {
                        YayMgr.addPost(msgObj)
                    }
                })
            }
            
           

        }
        else if isMiles {
            //Criteria for floors
            
            if( dailyCount < YayMgr.userSettings.minMiles){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getBooMsg()
                    isYay = false
                    self.registerNotification(dailyCount.description + " Miles!! " + msgDesc,Yay: isYay)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Miles!! ",Description: msgDesc, Yay: isYay)
                    
                    if YayMgr.loaded {
                        YayMgr.addPost(msgObj)
                    }
                })
            }
            else if( dailyCount >= YayMgr.userSettings.maxMiles){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getYayMsg()
                    isYay = true
                    self.registerNotification(dailyCount.description + " Miles!! " + msgDesc,Yay: isYay)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Miles!! ",Description: msgDesc, Yay: isYay)
                    
                    if YayMgr.loaded {
                        YayMgr.addPost(msgObj)
                    }

                })
            }
            
            
        }
        
    }
    
    
    // Register Notifications : To be altered for different msgs
    static func registerNotification(msg : String,Yay: Bool){
        
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
        if YayMgr.userSettings.hasSound {
            if Yay {
                notification.soundName = "yay.mp3"
            }
            else {
                notification.soundName = "boo.mp3"
            }
        }
        else
        {
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        notification.alertBody = msg
        notification.fireDate = fireDate
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        
        
    }


    
}


