//
//  CommentModel.swift
//  Viegram
//
//  Created by Apple on 9/5/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    var profileImg : String?
    var comment = String()
    var comment_id = String()
    var total_likes = String()
    var display_name = String()
    var comment_userid = String()
    var time_ago = String()
    var likes = String()
    var mentionedPeople = [[String:Any]]()
    var postUserID = String()
    
    init(profileImg :String,comment : String,comment_id : String,total_likes : String,display_name : String,comment_userid : String,time_ago : String,likes : String,mentionedPeople : [[String:Any]],postUserId:String) {
        
         self.profileImg = profileImg
         self.comment = comment
         self.comment_id = comment_id
         self.total_likes = total_likes
         self.display_name = display_name
         self.comment_userid = comment_userid
         self.time_ago = time_ago
         self.likes = likes
         self.mentionedPeople = mentionedPeople
        self.postUserID = postUserId
    }
    
    
    func getprofileimage() -> String {
        return self.profileImg ?? ""
    }
    
    
    
}
