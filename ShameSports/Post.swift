//
//  Post.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


struct Post {
    let Poster : User
    let Points : [Int]
    var Comments : [Comment]
    let Text : Message
    let Timestamp : NSTimeInterval
    
    init (Poster : User,Points : [Int],Comments : [Comment],Text : Message,Timestamp: NSTimeInterval) {
        self.Poster = Poster
        self.Points = Points
        self.Comments = Comments
        self.Text  = Text
        self.Timestamp = Timestamp
    }
    
}