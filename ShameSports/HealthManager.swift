//
//  HealthManager.swift
//  ShameSports
//
//  Created by Sarah Suleri on 16/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    
    static var msgObj :Message = Message(Title: "",Description: "",Yay: false)
    
    let healthKitStore:HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
    }()
    
    let objStepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
    let objFlightsClimbed = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierFlightsClimbed)!
    let objDistanceWalkedRunning = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!
    
    var lstSteps: [HKQuantitySample] = []
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        let healthKitTypesToRead : NSSet = NSSet(set: [objStepsCount,objFlightsClimbed,objDistanceWalkedRunning ])
       

        healthKitStore?.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) -> Void in
            
            if success && error == nil{
                dispatch_async(dispatch_get_main_queue(),{
                    self.startObservingStepsChanges()
                
     //               self.startObservingFloorsChanges()
          
       //             self.startObservingMilesChanges()
                })
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
    
    // Reads Number of steps taken
    func readNumberOfStepsTaken(){
        
        let readStepsQuery = HKSampleQuery(sampleType: objStepsCount,
            predicate: nil,
            limit: 100,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    
                    self.lstSteps = results
                    print(self.lstSteps)
                }
        }
        
        
        healthKitStore?.executeQuery(readStepsQuery)
        
    }
    
    //Reads most recent sample of today i.e. from 12am
    func readMostRecentSample(sampleType:HKSampleType , completion: (([HKSample]!, NSError!) -> Void)!)
    {

        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let endDate = NSDate()
        let startDate = cal.startOfDayForDate(endDate)
        
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        let limit = 0
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                
                if let _ = error {
                    completion(nil,error)
                    return;
                }
                
                let mostRecentSample = results! as? [HKQuantitySample]
                if completion != nil {
                    completion(mostRecentSample,nil)
                }
        }
        self.healthKitStore!.executeQuery(sampleQuery)
    }
    
    // Observer Query
    
    lazy var types: Set<HKObjectType> = {
        return [self.objStepsCount, self.objFlightsClimbed, self.objDistanceWalkedRunning]
    }()
    
    
    //Predicate
    lazy var predicate: NSPredicate = {
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
    
    
    //Query
    lazy var querySteps: HKObserverQuery = {
        return HKObserverQuery(sampleType: self.objStepsCount,
            predicate: self.predicate,
            updateHandler: self.stepsChangedHandler)
    }()
    
    lazy var queryFloors: HKObserverQuery = {
        return HKObserverQuery(sampleType: self.objFlightsClimbed,
            predicate: self.predicate,
            updateHandler: self.floorsChangedHandler)
    }()
    
    
    lazy var queryMiles: HKObserverQuery = {
        return HKObserverQuery(sampleType: self.objDistanceWalkedRunning,
            predicate: self.predicate,
            updateHandler: self.milesChangedHandler)
    }()

    
    //Fetch Calls
    func fetchRecordedStepsISinceStartOfDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: objStepsCount,
            predicate: predicate,
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
        
        healthKitStore!.executeQuery(query)
        
    }
    
    func fetchRecordedFloorsSinceStartOfDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: objFlightsClimbed,
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
        
        healthKitStore!.executeQuery(query)
        
    }
    
    func fetchRecordedMilesSinceStartOfDay(){
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
            ascending: true)
        
        let query = HKSampleQuery(sampleType: objDistanceWalkedRunning,
            predicate: predicate,
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
        
        healthKitStore!.executeQuery(query)
        
    }
    
    //Change Handler
    
    func stepsChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedStepsISinceStartOfDay()
            
            completionHandler()
            
    }
    
    func floorsChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedFloorsSinceStartOfDay()
            
            completionHandler()
            
    }
    
    func milesChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedMilesSinceStartOfDay()
            
            completionHandler()
            
    }
    
    //Start Observation
    func startObservingStepsChanges(){
        healthKitStore!.executeQuery(querySteps)
        healthKitStore!.enableBackgroundDeliveryForType(objStepsCount,
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
    
    func startObservingFloorsChanges(){
        healthKitStore!.executeQuery(queryFloors)
        healthKitStore!.enableBackgroundDeliveryForType(objFlightsClimbed,
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
    func startObservingMilesChanges(){
        healthKitStore!.executeQuery(queryMiles)
        healthKitStore!.enableBackgroundDeliveryForType(objDistanceWalkedRunning,
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
    func stopObservingStepsChanges(){
        healthKitStore!.stopQuery(querySteps)
        healthKitStore!.disableAllBackgroundDeliveryWithCompletion{
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

    
    func stopObservingFloorsChanges(){
        healthKitStore!.stopQuery(queryFloors)
        healthKitStore!.disableAllBackgroundDeliveryWithCompletion{
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
    
    func stopObservingMilesChanges(){
        healthKitStore!.stopQuery(queryMiles)
        healthKitStore!.disableAllBackgroundDeliveryWithCompletion{
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

    
    
    // HK : Load Data : Sample Queries for testing
    
    func readSteps(){
        
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        self.readMostRecentSample(sampleType!, completion: { (mostRecentSteps, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading steps taken from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
            let steps = mostRecentSteps.first as? HKQuantitySample;
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
        
        self.readMostRecentSample(sampleType!, completion: { (mostRecentFloors, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading number of floors climbed from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
            let floors = mostRecentFloors.first as? HKQuantitySample;
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
        self.readMostRecentSample(sampleType!, completion: { (mostRecentDistance, error) -> Void in
            
            if( error != nil )
            {
                print("Error reading distance walked from HealthKit Store: \(error.localizedDescription)")
                return;
            }
            
            
            let distanceWalked = mostRecentDistance.first as? HKQuantitySample;
            
            var dailyAVG:Double = 0
            for _distance in mostRecentDistance as! [HKQuantitySample]
            {
                dailyAVG += _distance.quantity.doubleValueForUnit(HKUnit.mileUnit())
            }
            print(dailyAVG)
            
            
        });
    }


    // Criteria to show msgs<
    static func criteriaToShowMsg(dailyCount: Int, isStep:Bool , isFloor: Bool, isMiles: Bool){
        
        var msgDesc : String = ""
        var isYay: Bool = true
        
        
        if isStep {
            if( dailyCount < 200){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getBooMsg()
                    isYay = false
                    YayMgr.registerNotification(dailyCount.description + " Steps!! " + msgDesc)
                    
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Steps!! ",Description: msgDesc, Yay: isYay)
                    
                })
            }
            else if( dailyCount >= 200){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getYayMsg()
                    isYay = true
                    YayMgr.registerNotification(dailyCount.description + " Steps!! " + msgDesc)
                    
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Steps!! ",Description: msgDesc, Yay: isYay)
                    
                })
            }
            
            
        }
        else if isFloor {
            //Criteria for floors
            
            if( dailyCount < 3){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getBooMsg()
                    isYay = false
                    YayMgr.registerNotification(dailyCount.description + " Floors!! " + msgDesc)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Floors!! ",Description: msgDesc, Yay: isYay)
                })
            }
            else if( dailyCount >= 3){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getYayMsg()
                    isYay = true
                    YayMgr.registerNotification(dailyCount.description + " Floors!! " + msgDesc)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Floors!! ",Description: msgDesc, Yay: isYay)
                })
            }
            
           

        }
        else if isMiles {
            //Criteria for floors
            
            if( dailyCount < 3){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getBooMsg()
                    isYay = false
                    YayMgr.registerNotification(dailyCount.description + " Miles!! " + msgDesc)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Miles!! ",Description: msgDesc, Yay: isYay)

                })
            }
            else if( dailyCount >= 3){
                dispatch_async(dispatch_get_main_queue(), {
                    msgDesc = YayMgr.getYayMsg()
                    isYay = true
                    YayMgr.registerNotification(dailyCount.description + " Miles!! " + msgDesc)
                    // Msg object
                    msgObj  = Message(Title: dailyCount.description + " Miles!! ",Description: msgDesc, Yay: isYay)

                })
            }
            
            
        }
    }

    
}


