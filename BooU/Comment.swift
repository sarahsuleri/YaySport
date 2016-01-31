//
//  Comment.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class Comment {
    
    let Commentor : User
    let Comment : String
    let Timestamp: NSTimeInterval
    
    init(Commentor : User, Comment : String, Timestamp: NSTimeInterval) {
        self.Commentor = Commentor
        self.Comment = Comment
        self.Timestamp = Timestamp
    }
    
}