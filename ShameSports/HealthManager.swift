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
                dispatch_async(dispatch_get_main_queue(),
                    self.startObservingStepsChanges)
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
        return [self.objStepsCount]
    }()
    
    
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
    
    lazy var query: HKObserverQuery = {
        return HKObserverQuery(sampleType: self.objStepsCount,
            predicate: self.predicate,
            updateHandler: self.stepsChangedHandler)
    }()
    
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
                
                YayMgr.criteriaToShowMsg(dailyAVG)
                
        })
        
        healthKitStore!.executeQuery(query)
        
    }
    
    func stepsChangedHandler(query: HKObserverQuery,
        completionHandler: HKObserverQueryCompletionHandler,
        error: NSError?){
            
            fetchRecordedStepsISinceStartOfDay()
            
            completionHandler()
            
    }
    
    func startObservingStepsChanges(){
        healthKitStore!.executeQuery(query)
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
    
    func stopObservingStepsChanges(){
        healthKitStore!.stopQuery(query)
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

    
}


