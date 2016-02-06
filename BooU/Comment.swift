//
//  Comment.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class Comment: Hashable {
    
    let Commentor : User
    let Comment : String
    let Timestamp: NSTimeInterval
    
    init(Commentor : User, Comment : String, Timestamp: NSTimeInterval) {
        self.Commentor = Commentor
        self.Comment = Comment
        self.Timestamp = Timestamp
    }
    
    var hashValue: Int {
        return Commentor.Id
    }
}

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.Commentor.Id == rhs.Commentor.Id
}