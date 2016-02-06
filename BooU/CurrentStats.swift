//
//  CurrentStats.swift
//  BooU
//
//  Created by Sarah Suleri on 04/02/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class CurrentStats{
    
     var numberOfSteps : Int = 0
     var numberOfFloors : Int = 0
     var numberOfMiles : Int = 0
    
    init(){
        self.numberOfSteps = 0
        self.numberOfFloors = 0
        self.numberOfMiles = 0
    }
    
    init(steps: Int, floors: Int, miles: Int){
        self.numberOfSteps = steps
        self.numberOfFloors = floors
        self.numberOfMiles = miles
        
    }
    
    
     func hasAchievedMaxSteps() -> Bool{
        if self.numberOfSteps >= YayMgr.userSettings.maxSteps{
            return true
        }
        else{
            return false
        }
    }
    
     func hasAchievedMaxFloors() -> Bool{
        if self.numberOfFloors >= YayMgr.userSettings.maxFloors{
            return true
        }
        else{
            return false
        }
    }
    
     func hasAchievedMaxMiles() -> Bool{
        if self.numberOfMiles >= YayMgr.userSettings.maxMiles{
            return true
        }
        else{
            return false
        }
    }
}