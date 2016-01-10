//
//  YayMgr.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class YayMgr {
    static var myPosts : [Post] = []
    static var FrPosts : [Post] = []
    static var BooMsg : [Message] = []
    static var YayMsg : [Message] = []
    static var loaded : Bool = false
    
    static func load() {
        
        // this to be changed to  load from firebase
        loaded = true
        myPosts = DummyD.getMyPost()
        FrPosts = DummyD.getFrPost()
        YayMsg.append(m0)
        YayMsg.append(m2)
        BooMsg.append(m1)
        BooMsg.append(m3)
        
        
        
    }

}