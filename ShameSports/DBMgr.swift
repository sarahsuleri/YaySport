//
//  testFirebase.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 26/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation



class DBMgr {

    
    static let ref = Firebase(url:  "https://yaysport.firebaseio.com")
    
    static func addPost(post : Post) {
        let autiId = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/").childByAutoId()
        autiId.setValue( convertStringToDictionary(JSONSerializer.toJson(post)) )
    }
    
    
    static func getPostByPosterID(Id : Int, isMyActivity : Bool = true ) {
      let postsRef = ref.childByAppendingPath("users/\(Id)/posts/")
        postsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let pDic = snapshot.value["Poster"] as! NSDictionary
            let poster : User = User(Id: pDic["Id"] as! Int, FirstName: pDic["FirstName"] as! String, LastName: pDic["LastName"]as! String, PhotoUrl: pDic["PhotoUrl"]as! String)
            
            var comments : [Comment] = []
            
            if let cDic = snapshot.value["Comments"] as? NSDictionary {
                for (_, com) in cDic {
                    let commentor :  User = User(Id: com["Commentor"]!!["Id"] as! Int, FirstName: com["Commentor"]!!["FirstName"] as! String, LastName: com["Commentor"]!!["LastName"]as! String, PhotoUrl: com["Commentor"]!!["PhotoUrl"]as! String)
                    comments.append(Comment(Commentor: commentor, Comment: com["Comment"] as! String, Timestamp: com["Timestamp"] as! NSTimeInterval))
                }
            }
            
            
            let mDic = snapshot.value["Text"] as! NSDictionary
            let message : Message = Message(Title: mDic["Title"] as! String, Description: mDic["Description"] as! String, Yay: mDic["Id"] as! Bool)
            
            var points : [Int] = []
            if let pointsDic = snapshot.value["Points"] as! [Int]? {
                points = pointsDic
            }
           
            
            
            let timeInt = snapshot.value["Timestamp"] as! NSTimeInterval
            
            
            
            let post : Post = Post(Poster: poster, Points: points, Comments: comments, Text: message, Timestamp: timeInt)
            post.DBIndex = snapshot.key
            
            if (isMyActivity == true){
                var index = YayMgr.myPosts.indexOf({$0.Timestamp > post.Timestamp})
                index = index == nil ? 0 : index
                YayMgr.myPosts.insert(post, atIndex: index!)
            } else {
                var index = YayMgr.FrPosts.indexOf({$0.Timestamp > post.Timestamp})
                index = index == nil ? 0 : index
                YayMgr.FrPosts.insert(post, atIndex: index!)
            }

        })
        
    }
    
    
    static func getMessages() {
        let msgRef = ref.childByAppendingPath("messages")
        msgRef.observeEventType(.Value, withBlock: { snapshot in
            let enumerator = snapshot.children
            while let snapChild = enumerator.nextObject() as? FDataSnapshot {
                let msg = Message(Title: "", Description: snapChild.value["Description"] as! String, Yay: snapChild.value["Yay"] as! Bool)
                if msg.Yay {
                    YayMgr.YayMsg.append(msg)
                } else {
                    YayMgr.BooMsg.append(msg)
                }
            }
        })
    }
    
    
    static func addPoint(post: Post) {
        post.Points.append(YayMgr.owner.Id)
        let pointsRef = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/\(post.DBIndex)/Points")
        pointsRef.setValue(post.Points)
    }
    
    static func removePoint(post: Post) {
        post.Points = post.Points.filter() {$0 != YayMgr.owner.Id}
        let pointsRef = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/\(post.DBIndex)/Points")
        pointsRef.setValue(post.Points)
    }
    
    static func addComment(comment: Comment, post: Post) {
        let commentsRef = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/\(post.DBIndex)/Comments").childByAutoId()
        commentsRef.setValue( convertStringToDictionary(JSONSerializer.toJson(comment)) )
    }
}
