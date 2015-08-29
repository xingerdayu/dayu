//
//  User.swift
//  Community
//
//  Created by Xinger on 15/3/16.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class User: NSObject {
   
    var id = 1;
    var tel = "";
    var regTime:Int64 = 0;
    var havePhoto = 0
    
    var intro:String?;
    var maxLost:Float?;
    var profit:Float?;
    var transNum:Int?;
    var username:String?;
    var winRate:Float?;
    
    var score:Float?;
    var fans:Int?;
    var copyNum = 0
    
    var pwd = ""
    
    class func parseUser(dict:NSDictionary) -> User {
        var user = User();
        user.id = dict["id"] as Int
        user.tel = dict["tel"] as String
        user.regTime = (dict["register_time"] as NSString).longLongValue
        
        user.score = dict["avgScore"] as? Float
        user.fans = dict["fansCount"] as? Int
        user.havePhoto = dict["havePhoto"] as Int
        
        //Get maybe null value field
        user.intro = dict["intro"] as? String
        user.maxLost = dict["max_lost"] as? Float
        user.profit = dict["profit"] as? Float
        user.winRate = dict["win_rate"] as? Float
        user.transNum = dict["trans_num"] as? Int
        user.username = dict["username"] as? String
        user.copyNum = dict["copy_num"] as Int

        return user
    }
    
    class func getUser(dict:NSDictionary) -> User {
        var user = User()
        user.id = dict["id"] as Int
        user.tel = dict["tel"] as String
        user.username = dict["username"] as? String
        user.intro = dict["intro"] as? String
        var havePhoto = dict["havePhoto"] as? Int
        if havePhoto != nil {
            user.havePhoto = havePhoto!
        }
        var copyNum = dict["copyNum"] as? Int
        if copyNum != nil {
            user.copyNum = dict["copyNum"] as Int
        }
        return user
    }
    
    func getUsername() -> String {
        var name = username == nil ? "\(id)" : username
        return name!
    }
    
    func getShowUsername() -> String {
        var name = username == nil ? "新用户" : username
        return name!
    }
    
    func getLocalImageName() -> String {
        return "U\(id).jpg"
    }
}
