//
//  CurrentStats.swift
//  BooU
//
//  Created by Sarah Suleri on 04/02/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class CurrentStats{
    
    static var numberOfSteps : Int = 0
    static var numberOfFloors : Int = 0
    static var numberOfMiles : Int = 0
    
    
    init(steps: Int, floors: Int, miles: Int){
        CurrentStats.numberOfSteps = steps
        CurrentStats.numberOfFloors = floors
        CurrentStats.numberOfMiles = miles
        
    }
    
    
    static func hasAchievedMaxSteps() -> Bool{
        if CurrentStats.numberOfSteps >= YayMgr.userSettings.maxSteps{
            return true
        }
        else{
            return false
        }
    }
    
    static func hasAchievedMaxFloors() -> Bool{
        if CurrentStats.numberOfFloors >= YayMgr.userSettings.maxFloors{
            return true
        }
        else{
            return false
        }
    }
    
    static func hasAchievedMaxMiles() -> Bool{
        if CurrentStats.numberOfMiles >= YayMgr.userSettings.maxMiles{
            return true
        }
        else{
            return false
        }
    }
}