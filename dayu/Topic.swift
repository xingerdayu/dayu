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
    
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    class func parseTopic(dict:NSDictionary) -> Topic {
        let topic = Topic()
        topic.content = dict["content"] as! NSString
        topic.agreeCount = dict["agreeCount"] as! Int
        topic.groupId = dict["group_id"] as? Int
        topic.id = dict["id"] as! Int
        topic.imageNum = dict["image_num"] as! Int
        topic.isShare = dict["is_reprint"] as! Int
        topic.originId = dict["origin_id"] as? Int
        topic.replyCount = dict["replyCount"] as! Int
        topic.sendtime = (dict["sendtime"] as! NSString).longLongValue
        topic.shareCount = dict["share_num"] as! Int
        topic.shareCode = dict["share_code"] as! String
        topic.userId = dict["user_id"] as! Int
        topic.username = dict["username"] as! String
        topic.visible = dict["visible"] as! String
        topic.disagreeCount = dict["disagreeCount"] as! Int
        topic.isSupport = dict["isSupport"] as? Int
        
        topic.timeString = StringUtil.formatTime(topic.sendtime)
        
        return topic
    }
    
    func getContentOffsetX() -> CGFloat {
        return 20;
    }
    
    func getContentOffsetY() -> CGFloat {
        return 55; //头像高度 50 + 上下间距 5
    }
    
    func getContentWidth() -> CGFloat {
        return app.ScreenWidth - getContentOffsetX() - getContentOffsetX() //减去左右边距
    }
    
    func getContentHeight() -> CGFloat {
        let size = content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(getContentWidth(), 20000));
        return size.height
    }
    
    func getImageGroupHeight() -> CGFloat {
        if imageNum > 0 {
            return 80 //默认高80个像素
        }
        return 0
    }
    
    func getImageOffsetY() -> CGFloat {
        return getContentOffsetY() + getContentHeight() + 5 //上下间距5个像素
    }
    
    /**
    计算TopicView的高度
    **/
    func getTopicHeight() -> CGFloat {
        return getImageOffsetY() + getImageGroupHeight()
    }

    func getAllHeight(shouldShowItems:Bool) -> CGFloat {
        if shouldShowItems {
            return getTopicHeight() + 30 * app.autoSizeScaleY //选项高度30
        } else {
            return getTopicHeight()
        }
    }
}
