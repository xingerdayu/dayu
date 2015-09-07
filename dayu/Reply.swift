//
//  Reply.swift
//  Community
//
//  Created by Xinger on 15/3/22.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class Reply: NSObject {
   
    var content:NSString = "";
    var id = 0;
    var sendtime:Int64 = 0;
    var topicId = 0;
    var userId = 0;
    var username = "";
    var timeString = "";
    
    var replyId:Int?
    var receiver:String?
    
    class func parseReply(dict:NSDictionary) -> Reply {
        var reply = Reply()
        reply.content = dict["content"] as NSString
        reply.id = dict["id"] as Int
        
        let tmp = (dict["sendtime"] as? NSString)?.longLongValue
        if tmp != nil { //一直想不明白，在列表中循环解析就要转化为NSString,而单个直接解析时需要用NSNumber
            reply.sendtime = tmp!
        } else {
            reply.sendtime = (dict["sendtime"] as NSNumber).longLongValue
        }
        reply.topicId = dict["attach_id"] as Int
        reply.userId = dict["user_id"] as Int
        reply.username = dict["username"] as String
        
        reply.replyId = dict["reply_id"] as? Int
        reply.receiver = dict["receiver"] as? String
        
        if reply.receiver != nil {
            reply.content = "回复\(reply.receiver!):\(reply.content)"
        }
        
        reply.timeString = StringUtil.formatTime(reply.sendtime)
        return reply
    }
}
