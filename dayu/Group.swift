//
//  Group.swift
//  Community
//
//  Created by Xinger on 15/3/17.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//
class Group: NSObject {
   
    var createTime:Int64 = 0
    var intro:String?
    var grade = 0
    var creater = ""
    var name = ""
    var id = 0
    var userLimit = 0
    
    var timeString = ""
    var inviteCode:String!
    var place:Int?;
    var imagePath:String?
    
    var num = 0 /**群组人数**/
    var on = false /**用户是否在该群组中**/
    
    func parse(dict:NSDictionary) {
        id = dict["id"] as! Int
        createTime = (dict["create_time"] as! NSString).longLongValue
        grade = dict["grade"] as! Int
        creater = dict["creater"] as! String
        name = dict["name"] as! String
        userLimit = dict["user_limit"] as! Int
        num = dict["num"] as! Int
        timeString = StringUtil.formatTime(createTime) as String
        intro = dict["intro"] as? String
        inviteCode = dict["invite_code"] as? String
        place = dict["place"] as? Int
        imagePath = dict["image_path"] as? String
        
        if dict["on"] != nil {
            self.on = dict["on"]!.boolValue
        }
    }
    
}

class GroupInfo: Group {
    var winNum = 0 /**群组盈利的人数**/
    var avgProfit:Float = 0 /**平均盈利**/
    var avgWinPercent:Float = 0 /**平均胜率**/
    var rank:Float = 0 /**排名**/
    var userList = Array<User>()
    
    override func parse(dict:NSDictionary) {
        super.parse(dict)
        
        winNum = dict["winNum"] as! Int
        avgProfit = dict["avgProfit"] as! Float
        avgWinPercent = dict["avgWinPercent"] as! Float
        rank = dict["rank"] as! Float
        
        let array = dict["users"] as! NSArray
        for item in array {
            let user = User()
            user.parse(item as! NSDictionary)
            userList.append(user)
        }

    }
    
}