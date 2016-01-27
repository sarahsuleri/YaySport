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
        let autiId = ref.childByAppendingPath("tests").childByAutoId()
        autiId.setValue( convertStringToDictionary(JSONSerializer.toJson(post)) )
    }
    
    
    static func getPostByPosterID(Id : Int, isMyActivity : Bool = true ) {
      let postsRef = ref.childByAppendingPath("tests")
        postsRef.queryOrderedByChild("/Poster/Id").queryEqualToValue(Id).observeEventType(.ChildAdded, withBlock: { snapshot in
            let pDic = snapshot.value["Poster"] as! NSDictionary
            let poster : User = User(Id: pDic["Id"] as! Int, FirstName: pDic["FirstName"] as! String, LastName: pDic["LastName"]as! String, PhotoUrl: pDic["PhotoUrl"]as! String)
            
            let cDic = snapshot.value["Comments"] as! [NSDictionary]
            var comments : [Comment] = []
            for com in cDic {
                let commentor :  User = User(Id: com["Commentor"]!["Id"] as! Int, FirstName: com["Commentor"]!["FirstName"] as! String, LastName: com["Commentor"]!["LastName"]as! String, PhotoUrl: com["Commentor"]!["PhotoUrl"]as! String)
                comments.append(Comment(Commentor: commentor, Comment: com["Comment"] as! String))
               
            }
            let mDic = snapshot.value["Text"] as! NSDictionary
            let message : Message = Message(Id: mDic["Id"] as! Int, Title: mDic["Title"] as! String, Description: mDic["Description"] as! String, Yay: mDic["Id"] as! Bool)
            
            let points = snapshot.value["Points"] as! [Int]
            
            let timeInt = snapshot.value["Timestamp"] as! NSTimeInterval
            
            
            
            let post : Post = Post(Poster: poster, Points: points, Comments: comments, Text: message, Timestamp: timeInt)
            post.DBIndex = snapshot.key
            if (isMyActivity == true){
                YayMgr.myPosts.append(post)
            } else {
                YayMgr.FrPosts.append(post)
            }
        })
        
       
        
    }
}



class aa  {
    var poster: bb;
    var id : String
    // encode to serialize and save it using nsuserdefaults
    init (id:String){
        poster = bb(firstName: "bla", lastName: " sec")
        self.id = id
    }

}

class bb  {
    let firstName : String;
    let lastName : String;
    init (firstName : String, lastName : String){
        self.firstName = firstName
        self.lastName = lastName
    }

}

/*: NSObject, NSCoding
required init?(coder decoder: NSCoder) {
self.firstName = (decoder.decodeObjectForKey("firstName") as? String)!
self.lastName = (decoder.decodeObjectForKey("lastName") as? String)!
super.init()
}
func encodeWithCoder(coder: NSCoder) {
coder.encodeObject(self.firstName, forKey: "firstName")
coder.encodeObject(self.lastName, forKey: "lastName")
}    

required init?(coder decoder: NSCoder) {
        self.poster = (decoder.decodeObjectForKey("poster") as? bb)!
        self.id = (decoder.decodeObjectForKey("id") as? String)!
        super.init()
    }
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.poster, forKey: "poster")
        coder.encodeObject(self.id, forKey: "id")
    }

*/