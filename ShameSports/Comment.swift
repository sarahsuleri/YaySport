//
//  Comment.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


struct Comment {
    
    let Commentor : User
    let Comment : String
    
    init(Commentor : User, Comment : String){
        self.Commentor = Commentor
        self.Comment = Comment
    }
    
}