//
//  Post.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class Post {
    let Poster : User
    let Points : [Int]
    var Comments : [Comment]
    let Text : Message
    
    init (Poster : User,Points : [Int],Comments : [Comment],Text : Message){
        self.Poster = Poster
        self.Points = Points
        self.Comments = Comments
        self.Text  = Text
    }
    
}