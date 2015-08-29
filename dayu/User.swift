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
    
//    func parse(dict:NSDictionary) {
//        id = dict["id"] as Int
//        tel = dict["tel"] as String
//        regTime = (dict["register_time"] as NSString).longLongValue
//        
//        score = dict["avgScore"] as? Float
//        fans = dict["fansCount"] as? Int
//        havePhoto = dict["havePhoto"] as Int
//        
//        //Get maybe null value field
//        intro = dict["intro"] as? String
//        maxLost = dict["max_lost"] as? Float
//        profit = dict["profit"] as? Float
//        winRate = dict["win_rate"] as? Float
//        transNum = dict["trans_num"] as? Int
//        username = dict["username"] as? String
//        copyNum = dict["copy_num"] as Int
//    }
    
    func parse(dict:NSDictionary) {
        id = dict["id"] as Int
        tel = dict["tel"] as String
        username = dict["username"] as? String
        intro = dict["intro"] as? String
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
