//
//  DummyData.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation



var u0 = User(Id: 23156,FirstName: "Jon",LastName: "Do",PhotoUrl: "http://download6.acadox.net/user/1356/50.jpg?v=3")
var u1 = User(Id: 23156,FirstName: "Dave",LastName: "Do",PhotoUrl: "http://download3.acadox.net/user/8443/50.jpg?v=4")
var u2 = User(Id: 23156,FirstName: "Maria",LastName: "Do",PhotoUrl: "http://download6.acadox.net/user/8426/50.jpg?v=1")
var u3 = User(Id: 23156,FirstName: "Saad",LastName: "Do",PhotoUrl: "http://download4.acadox.net/user/8454/50.jpg?v=1")
var u4 = User(Id: 23156,FirstName: "Maha",LastName: "Do",PhotoUrl: "http://download1.acadox.net/user/8441/50.jpg?v=5")
var u5 = User(Id: 23156,FirstName: "Raghad",LastName: "Do",PhotoUrl: "http://download6.acadox.net/user/1356/50.jpg?v=3")
var u6 = User(Id: 23156,FirstName: "Omar",LastName: "Do",PhotoUrl: "http://download1.acadox.net/user/8451/50.jpg?v=1")
var u7 = User(Id: 23156,FirstName: "Steph",LastName: "Do",PhotoUrl: "http://download8.acadox.net/user/8738/50.jpg?v=2")

var m0 = Message(Id: 0, Title: "100 Step", Description: "Great Work", Yay: true)
var m1 = Message(Id: 1, Title: "2 Step", Description: "When your friends tell you look good, ditch them, they are all a bunch of liars", Yay: false)
var m2 = Message(Id: 2, Title: "300 floor", Description: "At this rate you will reach heaven", Yay: true)
var m3 = Message(Id: 3, Title: "1 Miles", Description: "We see that you found your soulmate, Your couch. When is the wedding ", Yay: false)

var c0 = Comment(Commentor: u1, Comment: "Bla Bla")
var c1 = Comment(Commentor: u2, Comment: "Bla Bla")
var c2 = Comment(Commentor: u3, Comment: "Bla Bla")
var c3 = Comment(Commentor: u4, Comment: "Bla Bla")
var c4 = Comment(Commentor: u5, Comment: "Bla Bla")
var c5 = Comment(Commentor: u6, Comment: "Bla Bla")
var c6 = Comment(Commentor: u7, Comment: "Bla Bla")






class DummyD {
    static var myPosts : [Post] = []
    static var FrPosts : [Post] = []
    
    /*
    static func getMyPost() -> [Post] {
        myPosts.append(Post(Poster: u0, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21], Comments: [c2,c3,c4,c5,c6], Text: m1))
        myPosts.append(Post(Poster: u0, Points: [1,2,3,4,5,6,7,8,9,10,11], Comments: [c0,c1,c3,c4,c5,c6], Text: m2))
        myPosts.append(Post(Poster: u0, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,], Comments: [c0,c1,c2,c5,c6], Text: m3))
        myPosts.append(Post(Poster: u0, Points: [1,2,3,4,5,6], Comments: [c0,c1,c2,], Text: m0))
        myPosts.append(Post(Poster: u0, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,1], Comments: [c2,c3,c4], Text: m3))
        myPosts.append(Post(Poster: u0, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20], Comments: [c0,c1,c2,c3,c4,c5,c6], Text: m2))
        return myPosts
    }
    static func getFrPost() -> [Post] {
        FrPosts.append(Post(Poster: u1, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], Comments: [c0,c1,c2,c3], Text: m0))
        FrPosts.append(Post(Poster: u2, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21], Comments: [c2,c3,c4,c5,c6], Text: m1))
        FrPosts.append(Post(Poster: u3, Points: [1,2,3,4,5,6,7,8,9,10,11], Comments: [c0,c1,c6], Text: m2))
        FrPosts.append(Post(Poster: u4, Points: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16], Comments: [c3,c4,c5,c6], Text: m3))
        FrPosts.append(Post(Poster: u5, Points: [1,2,3,4,5,6], Comments: [c0,c1,c2,c3,c6], Text: m1))
        FrPosts.append(Post(Poster: u6, Points: [1,2,3,4,5,6,7,8,9], Comments: [c0,c1,c2,c3,c4,c5,c6], Text: m2))
        return FrPosts
    }
    */
   
}


