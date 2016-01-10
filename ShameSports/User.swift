//
//  User.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation

class User {
    
    let Id : Int
    let FirstName : String
    let LastName : String
    let PhotoUrl : String
    
    
    init ( Id: Int, FirstName : String, LastName : String,  PhotoUrl : String ){
        self.Id = Id
        self.FirstName = FirstName
        self.LastName = LastName
        self.PhotoUrl = PhotoUrl
    }
    
}
