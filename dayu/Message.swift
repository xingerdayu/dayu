//
//  Message.swift
//  Community
//
//  Created by Xinger on 15/3/24.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

struct MessageStat {
    static let UnRead = 0
    static let Readed = 1
    static let All = 2
}

class Message: NSObject {
    
    var id = 0
    var sendId = 0
    var receiverId = 0
    var msgType = 0
    var attachId = 0
    var title = ""
    var content = ""
    var createTime:Int64 = 0
    var status = 0
    var username = ""
    
    class func parseMessage(dict:NSDictionary) -> Message {
        var msg = Message()
        msg.id = dict["id"] as Int
        msg.sendId = dict["send_id"] as Int
        msg.receiverId = dict["receiver_id"] as Int
        msg.msgType = dict["msg_type"] as Int
        msg.attachId = dict["attach_id"] as Int
        msg.title = dict["title"] as String
        msg.content = dict["content"] as String
        msg.createTime = (dict["create_time"] as NSString).longLongValue
        msg.status = dict["status"] as Int
        msg.username = dict["username"] as String
        return msg
    }
   
}
