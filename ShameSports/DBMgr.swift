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
        print("===========================")
        print(YayMgr.myPosts.count)
      let postsRef = ref.childByAppendingPath("users/\(Id)/posts/")
        postsRef.observeEventType(.ChildAdded, withBlock: { snapshot in
            let pDic = snapshot.value["Poster"] as! NSDictionary
            let poster : User = User(Id: pDic["Id"] as! Int, FirstName: pDic["FirstName"] as! String, LastName: pDic["LastName"]as! String, PhotoUrl: pDic["PhotoUrl"]as! String)
            
            var comments : [Comment] = []
            if let cDic = snapshot.value["Comments"] as? [NSDictionary] {
                for com in cDic {
                    let commentor :  User = User(Id: com["Commentor"]!["Id"] as! Int, FirstName: com["Commentor"]!["FirstName"] as! String, LastName: com["Commentor"]!["LastName"]as! String, PhotoUrl: com["Commentor"]!["PhotoUrl"]as! String)
                    comments.append(Comment(Commentor: commentor, Comment: com["Comment"] as! String))
                   
                }
            }
            let mDic = snapshot.value["Text"] as! NSDictionary
            let message : Message = Message(Id: mDic["Id"] as! Int, Title: mDic["Title"] as! String, Description: mDic["Description"] as! String, Yay: mDic["Id"] as! Bool)
            
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
}
