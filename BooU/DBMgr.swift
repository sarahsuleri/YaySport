//
//  testFirebase.swift
//  BooU
//
//  Created by Mohammad Alhareeqi on 26/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation
import Firebase

class DBMgr {

    // Declare Firebase reference and array of its listeners
    static let ref = Firebase(url:  "https://yaysport.firebaseio.com")
    static var refArray = [ref]
    
    // Add Post to Firebase
    static func addPost(post : Post) {
        let postAutoId = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/").childByAutoId()
        postAutoId.setValue( convertStringToDictionary(JSONSerializer.toJson(post)) )
        refArray.append(postAutoId)
    }
    
    // Change an existing Post knowing its Poster's id
    static func changePostByPosterID(Id : Int, isMyActivity : Bool = true ) {
        let postsRef = ref.childByAppendingPath("users/\(Id)/posts/")
        postsRef.observeEventType(.ChildChanged, withBlock: { snapshot in
            let post = parseFToPost(snapshot)
            if (isMyActivity == true) {
                let index = YayMgr.myPosts.indexOf({$0.DBIndex == post.DBIndex})
                YayMgr.myPosts[index!] = post
            } else {
                let index = YayMgr.FrPosts.indexOf({$0.DBIndex == post.DBIndex})
                YayMgr.FrPosts[index!] = post
            }
        })
        refArray.append(postsRef)
    }
    
    // Get Post by Poster id (use: when want to get all friends' posts or my posts)
    static func getPostByPosterID(Id : Int, isMyActivity : Bool = true ) {
        changePostByPosterID(Id,isMyActivity: isMyActivity)
      let postsRef = ref.childByAppendingPath("users/\(Id)/posts/")
        postsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            let post = parseFToPost(snapshot)
            if (isMyActivity == true){
                var index = YayMgr.myPosts.indexOf({$0.Timestamp > post.Timestamp})
                index = index == nil ? 0 : index
                YayMgr.myPosts.insert(post, atIndex: index!)
            } else {
                var index = YayMgr.FrPosts.indexOf({$0.Timestamp < post.Timestamp})
                index = index == nil ? -1 : index
                index == -1 ? YayMgr.FrPosts.append(post) : YayMgr.FrPosts.insert(post, atIndex: index!)
            }
        })
        refArray.append(postsRef)
    }
    
    // Parsing function from Firebase Post snapshot dict to Post object
    static func parseFToPost(snapshot: FDataSnapshot) -> Post {
        let pDic = snapshot.value["Poster"] as! NSDictionary
        
        // Poster
        let poster : User = User(Id: pDic["Id"] as! Int, FirstName: pDic["FirstName"] as! String, LastName: pDic["LastName"]as! String, PhotoUrl: pDic["PhotoUrl"]as! String)
        
        // Comments
        var comments : [Comment] = []
        if let cDic = snapshot.value["Comments"] as? NSDictionary {
            for com in cDic.allValues {
                let commentor :  User = User(Id: com["Commentor"]!!["Id"] as! Int, FirstName: com["Commentor"]!!["FirstName"] as! String, LastName: com["Commentor"]!!["LastName"]as! String, PhotoUrl: com["Commentor"]!!["PhotoUrl"]as! String)
                comments.append(Comment(Commentor: commentor, Comment: com["Comment"] as! String, Timestamp: com["Timestamp"] as! NSTimeInterval))
            }
            comments.sortInPlace({$0.Timestamp < $1.Timestamp})
        }
        
        // Message
        let mDic = snapshot.value["Text"] as! NSDictionary
        let message : Message = Message(Title: mDic["Title"] as! String, Description: mDic["Description"] as! String, Yay: mDic["Yay"] as! Bool)
        
        // Points
        var points : [Int] = []
        if let pointsDic = snapshot.value["Points"] as! [Int]? {
            points = pointsDic
        }
        
        // Timestamp
        let timeInt = snapshot.value["Timestamp"] as! NSTimeInterval
        
        // Finally, initialize Post
        let post : Post = Post(Poster: poster, Points: points, Comments: comments, Text: message, Timestamp: timeInt)
        post.DBIndex = snapshot.key
        return post
    }
    
    // Get all Yay and Boo messages, make Title empty
    static func getMessages() {
        let msgRef = ref.childByAppendingPath("messages")
        msgRef.observeEventType(.Value, withBlock: { snapshot in
            let enumerator = snapshot.children
            while let snapChild = enumerator.nextObject() as? FDataSnapshot {
                let msg = Message(Title: "", Description: snapChild.value["Description"] as! String, Yay: snapChild.value["Yay"] as! Bool)
                if msg.Yay == true {
                    YayMgr.YayMsg.append(msg)
                } else {
                    YayMgr.BooMsg.append(msg)
                }
            }
        })
        refArray.append(msgRef)
    }
    
    // +1 Point
    static func addPoint(post: Post) {
        post.Points.append(YayMgr.owner.Id)
        let pointsRef = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/\(post.DBIndex)/Points")
        pointsRef.setValue(post.Points)
        refArray.append(pointsRef)
    }
    
    // -1 Point
    static func removePoint(post: Post) {
        post.Points = post.Points.filter() {$0 != YayMgr.owner.Id}
        let pointsRef = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/\(post.DBIndex)/Points")
        pointsRef.setValue(post.Points)
        refArray.append(pointsRef)
    }
    
    // Add comment to specific Post
    static func addComment(comment: Comment, post: Post) {
        let commentsRef = ref.childByAppendingPath("users/\(post.Poster.Id)/posts/\(post.DBIndex)/Comments").childByAutoId()
        commentsRef.setValue( convertStringToDictionary(JSONSerializer.toJson(comment)) )
        refArray.append(commentsRef)
    }
    
    // Delete all listeners
    static func removeAllObservers() {
        for ref in refArray {
            ref.removeAllObservers()
        }
    }
    
}
