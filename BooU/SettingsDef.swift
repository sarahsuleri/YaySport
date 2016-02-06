//
//  SettingsDef.swift
//  BooU
//
//  Created by Omar Tawfik on 29/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation

class SettingsDef {
    
    var minSteps:Int
    var maxSteps:Int
    
    var minMiles:Int
    var maxMiles:Int
    
    var minFloors:Int
    var maxFloors:Int
    
    var hasSound: Bool
    
    init()
    {
        self.minSteps = 2500
        self.maxSteps = 10000
        
        self.minMiles = 1
        self.maxMiles = 5
        
        self.minFloors = 3
        self.maxFloors = 10
        
        self.hasSound = true
    }
    
    init ( minStep: Int, maxStep: Int, minMile: Int, maxMile: Int, minFloor:Int, maxFloor: Int, _hasSound: Bool)
    {
        self.minSteps = minStep
        self.maxSteps = maxStep
        
        self.minMiles = minMile
        self.maxMiles = maxMile
        
        self.minFloors = minFloor
        self.maxFloors = maxFloor
        
        self.hasSound = _hasSound
    
    }
    
}