//
//  Topic.swift
//  Community
//
//  Created by Xinger on 15/3/19.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class Topic: NSObject {
    var content:NSString = ""
    var agreeCount = 0;
    var groupId:Int?;
    var id = 0;
    var imageNum = 0;
    var isShare = 0;
    var originId:Int?;
    var replyCount = 0;
    var disagreeCount = 0;
    var sendtime:Int64 = 0;
    var shareCount = 0;
    var userId = 0;
    var username = "";
    var visible = "";
    var shareCode:String = ""
    var timeString:NSString = ""
    var isSupport:Int?
    
    var imageGroupHeight:CGFloat = 0
    
    var contentLabelOffsetX:CGFloat = 20
    
    var contentLabelOffsetY:CGFloat = 60
    
    var contentLabelWidth:CGFloat = 280
    
    var defaultImageGroupHeight:CGFloat = 80
    
    var subViewOffsetY:CGFloat = 60
    
    var contentLabelHeight:CGFloat = 0
    
    var marginTop:CGFloat = 5
    
    var contentHeight:CGFloat = 0

    
    class func parseTopic(dict:NSDictionary) -> Topic {
        var topic = Topic()
        topic.content = dict["content"] as NSString
        topic.agreeCount = dict["agreeCount"] as Int
        topic.groupId = dict["group_id"] as? Int
        topic.id = dict["id"] as Int
        topic.imageNum = dict["image_num"] as Int
        topic.isShare = dict["is_reprint"] as Int
        topic.originId = dict["origin_id"] as? Int
        topic.replyCount = dict["replyCount"] as Int
        topic.sendtime = (dict["sendtime"] as NSString).longLongValue
        topic.shareCount = dict["share_num"] as Int
        topic.shareCode = dict["share_code"] as String
        topic.userId = dict["user_id"] as Int
        topic.username = dict["username"] as String
        topic.visible = dict["visible"] as String
        topic.disagreeCount = dict["disagreeCount"] as Int
        topic.isSupport = dict["isSupport"] as? Int
        
        topic.timeString = StringUtil.formatTime(topic.sendtime)
        
        return topic
    }
    
    /**
    计算TopicView的高度
    **/
    func getContentHeight() -> CGFloat {
        var size = content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(contentLabelWidth, 20000));
        
        if imageNum > 0 {
            imageGroupHeight = defaultImageGroupHeight
        }
        
        return contentLabelOffsetY + size.height + imageGroupHeight + marginTop * 3 + 30
    }


}
