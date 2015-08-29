//
//  Group.swift
//  Community
//
//  Created by Xinger on 15/3/17.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

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
    var place:Int = 0;
    
    var num = 0 /**群组人数**/
    var on = false /**用户是否在该群组中**/
    
    class func parseGroup(dict:NSDictionary) -> Group {
        var group = Group()
        group.id = dict["id"] as Int
        group.createTime = (dict["create_time"] as NSString).longLongValue
        group.grade = dict["grade"] as Int
        group.creater = dict["creater"] as String
        group.name = dict["name"] as String
        group.userLimit = dict["user_limit"] as Int
        group.num = dict["num"] as Int
        group.timeString = StringUtil.formatTime(group.createTime)
        group.intro = dict["intro"] as? String
        group.inviteCode = dict["invite_code"] as? String
        group.place = dict["place"] as Int
        var on = dict["on"] as? Int
        
        if on != nil {
            group.on = (dict["on"] as Int) > 0
        }
        return group
    }
    
}

class GroupInfo: NSObject {
    var group:Group!
    var winNum = 0 /**群组盈利的人数**/
    var avgProfit:Float = 0 /**平均盈利**/
    var avgWinPercent:Float = 0 /**平均胜率**/
    var rank:Float = 0 /**排名**/
    var userList = Array<User>()
    
    class func getGroupInfo(dict:NSDictionary) -> GroupInfo {
        var groupInfo = GroupInfo()
        groupInfo.group = Group.parseGroup(dict)
        groupInfo.winNum = dict["winNum"] as Int
        groupInfo.avgProfit = dict["avgProfit"] as Float
        groupInfo.avgWinPercent = dict["avgWinPercent"] as Float
        groupInfo.rank = dict["rank"] as Float
        
        var array = dict["users"] as NSArray
        for item in array {
            groupInfo.userList.append(User.getUser(item as NSDictionary))
        }
        
        return groupInfo
    }
}