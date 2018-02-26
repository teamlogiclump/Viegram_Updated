//
//  PointOnPostModel.swift
//  Viegram
//
//  Created by Apple on 9/6/17.
//  Copyright © 2017 Relinns. All rights reserved.
//

import UIKit

class PointOnPostModel: NSObject {
    var userId : String?
    var userImg: String?
    var userName: String?
    
    init(with userId : String?,userImg: String?, userName: String?) {
        self.userId = userId
        self.userImg = userImg
        self.userName = userName
    }
    func getUsername()-> String{
        return self.userName ?? ""
    }
    func getUserImage()-> String{
        return self.userImg ?? ""
    }
    func getUserId()-> String{
        return self.userId ?? ""
    }
}
