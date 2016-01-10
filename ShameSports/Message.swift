//
//  Message.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation

struct Message {
    let Id : Int
    let Title : String
    let Description : String
    let Yay : Bool
    
    init(Id : Int,Title : String, Description : String,Yay : Bool) {
        self.Id = Id
        self.Title = Title
        self.Description = Description
        self.Yay = Yay
        
    }
    
}