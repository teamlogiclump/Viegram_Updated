//
//  FeedPostModel.swift
//  Viegram
//
//  Created by Apple on 9/6/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class FeedPostModel: NSObject {

    var video :String?
    var imgurls :String?
    var DNames :String?
    var time :String?
    var caption :String?
    var repost_id1 :String?
    var profileImage : String?
    var post_like :String?
    var total_points1 :String?
    var user_id :String?
    var file_type1 :String?
    
    var image_width :Int?
    var image_height :Int?
    
    var tagpeople : [[String:Any]]?
    var x_cord : String?
    var y_cord : String?
    var multipleImages : String?
    
    
    init(video :String?,imgurls :String?,DNames :String?,time :String?,caption :String?,repost_id1 :String?,post_like :String?,total_points1 :String?,user_id :String?,file_type1 :String?,profileImage :String?, image_width :Int?,image_height :Int?,tagpeople : [[String:Any]]?,x_cord:String?,y_cord:String?,multipleImages:String?) {
        self.video = video
        self.imgurls = imgurls
        self.DNames = DNames
        self.time = time
        self.caption = caption
        self.repost_id1 = repost_id1
        self.profileImage = profileImage
        self.post_like = post_like
        self.total_points1 = total_points1
        self.user_id = user_id
        self.file_type1 = file_type1
        
        self.image_width = image_width
        self.image_height = image_height
        
        self.tagpeople = tagpeople
        self.x_cord = x_cord
        self.y_cord = y_cord
        self.multipleImages = multipleImages
    }
    func getVideoLink() -> String{
        return self.video ?? ""
    }
    func getimgurl() -> String{
        return self.imgurls ?? ""
    }
    func getDnames() -> String{
        return self.DNames ?? ""
    }
    func getTime() -> String{
        return self.time ?? ""
    }
    func getCaption() -> String{
        return self.caption ?? ""
    }
    func getrepost_id1() -> String{
        return self.repost_id1 ?? ""
    }
    func getpost_like() -> String{
        return self.post_like ?? ""
    }
    func gettotal_points1() -> String{
        return self.total_points1 ?? ""
    }
    func getuser_id() -> String{
        return self.user_id ?? ""
    }
    func getfile_type1() -> String{
        return self.file_type1 ?? ""
    }
    func getimage_width() -> Int{
        return self.image_width ?? 0
    }
    func getimage_height() -> Int{
        return self.image_height ?? 0
    }
    func gettagpeople() -> [[String:Any]]{
        return self.tagpeople ?? [[:]]
    }
    func getProfileImage() -> String{
        return self.profileImage ?? ""
    }
    func getx_cord() -> String{
        return self.x_cord ?? ""
    }
    func gety_cord() -> String{
        return self.y_cord ?? ""
    }
    func getmultipleImages() -> String{
        return self.multipleImages ?? ""
    }
 
    
}
