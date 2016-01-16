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
        let healthKitTypesToWrite = NSSet(set: [ objStepsCount])

        healthKitStore?.requestAuthorizationToShareTypes(healthKitTypesToWrite as? Set<HKSampleType>, readTypes: healthKitTypesToRead as? Set<HKObjectType>) { (success, error) -> Void in
            
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
    
}


