//
//  YayMgr.swift
//  ShameSports
//
//  Created by Mohammad Alhareeqi on 09/01/16.
//  Copyright © 2016 Daria. All rights reserved.
//

import Foundation


class YayMgr {
    
    static var firebase: Firebase = {
        let firebase = Firebase(url: "https://yaysport.firebaseio.com")
        return firebase
    }()
    
    static var userID = 0
    static var friendsIDs : [Int] = [107563939625133, 128929287485572]
    static var limitQueryTo : UInt = 50
    static var myPosts : [Post] = []
    static var FrPosts : [Post] = []
    static var BooMsg : [Message] = []
    static var YayMsg : [Message] = []
    static var loaded : Bool = false
    
    static func load() {
        // this to be changed to  load from firebase
        loaded = true
        //myPosts = loadPostsFromDB()
        //FrPosts = DummyD.getFrPost()
        loadFriendsPosts()
        loadMyPosts()
        YayMsg.append(m0)
        YayMsg.append(m2)
        BooMsg.append(m1)
        BooMsg.append(m3)
    }
    
    static func loadMyPosts() {
        myPosts.removeAll()
        loadPostByUserID(userID)
    }
    
    
    static func loadFriendsPosts() {
        FrPosts.removeAll()
        let postsRef = firebase.childByAppendingPath("posts")
        postsRef.queryLimitedToLast(limitQueryTo).observeEventType(.ChildAdded, withBlock: {snapshot in
            if friendsIDs.contains(snapshot.value["Poster"] as! Int) {
                //print("Load Post from ", snapshot.value["Poster"] as! Int)
                loadPost(snapshot, tag: "friends")
            }
        })
    }
    
    
    static func loadPostByUserID(id: Int) {
        let postsRef = firebase.childByAppendingPath("posts")
        
        postsRef.queryOrderedByChild("Poster").queryEqualToValue(id).observeEventType(.ChildAdded, withBlock: { snapshot in
            loadPost(snapshot, tag: "my")
        })
    }
    
    
    static func loadPost(snapshot: FDataSnapshot, tag: String) {
        
        // Get Poster ID
        let posterID = snapshot.value["Poster"] as! Int
        
        // Get Points
        let points = snapshot.value["Points"] as! [Int]
        
        // Get Post Owner
        getUserByID(posterID) { poster in
            
            // Get Message
            let textDict = snapshot.value["Text"] as! NSDictionary
            let title = textDict.valueForKey("Title") as! String
            let messageID = textDict.valueForKey("Message") as! Int
            getMessageByID(messageID, title: title) { text in
                
                // Get Comments
                loadComments(Int(snapshot.key)!) { comments in
                    
                    // Create a Post
                    let post = Post(Poster: poster, Points: points, Comments: comments, Text: text)
                    
                    if tag == "friends" {
                        FrPosts.insert(post, atIndex: 0)
                    } else {
                        myPosts.insert(post, atIndex: 0)
                    }
                    print("FrPosts size: ", FrPosts.count)
                }
            }
        }
    }
    
    static func getUserByID(id: Int, completionHandler: (User) -> ()) {
        let posterRef = firebase.childByAppendingPath("users/\(id)")
        posterRef.observeEventType(FEventType.Value) { (snapshot: FDataSnapshot!) -> Void in
            let poster = User(Id: id,
                FirstName: snapshot.value["FirstName"] as! String,
                LastName: snapshot.value["LastName"] as! String,
                PhotoUrl: snapshot.value["PhotoUrl"] as! String
            )
            completionHandler(poster)
        }
    }
    
    
    static func getMessageByID(id: Int, title: String, completionHandler: (Message) -> ()) {
        let messageRef = firebase.childByAppendingPath("messages/\(id)")
        messageRef.observeEventType(FEventType.Value) { (snapshot: FDataSnapshot!) -> Void in
            let message = Message(Id: id,
                Title: title,
                Description: snapshot.value["Description"] as! String,
                Yay: snapshot.value["Yay"] as! Bool
            )
            completionHandler(message)
        }
    }
    
    
    static func loadComments(postId: Int, completionHandler: ([Comment]) -> ()) {
        var comments = [Comment]()
        let commentsRef = firebase.childByAppendingPath("comments")
        
        commentsRef.queryOrderedByChild("PostID").queryEqualToValue(postId).observeEventType(.Value, withBlock: { snapshot in
            
            let loadCommentorGroup = dispatch_group_create()
            let enumerator = snapshot.children
            while let snapChild = enumerator.nextObject() as? FDataSnapshot {
                dispatch_group_enter(loadCommentorGroup)
                getUserByID(snapChild.value!["Commentor"] as! Int) { commentor in
                    let comment = Comment(Commentor: commentor,
                        Comment: snapChild.value!["Comment"] as! String)
                    comments.append(comment)
                    dispatch_group_leave(loadCommentorGroup)
                }
            }
            dispatch_group_notify(loadCommentorGroup, dispatch_get_main_queue()) {
                completionHandler(comments)
            }
        })
    }
    
    // Probably delete
    static func getCommentByID(id: Int, completionHandler: (Comment) -> ()) {
        let commentRef = firebase.childByAppendingPath("comments/\(id)")
        commentRef.observeEventType(FEventType.Value) { (snapshot: FDataSnapshot!) -> Void in
            getUserByID(snapshot.value["Commentor"] as! Int) { commentor in
                let comment = Comment(Commentor: commentor,
                    Comment: snapshot.value["Comment"] as! String)
                completionHandler(comment)
            }
        }
    }

}