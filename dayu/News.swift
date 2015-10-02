//
//  News.swift
//  Community
//
//  Created by Xinger on 15/4/12.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class News: NSObject {
   
    var id = 0
    var title = ""
    var content = ""
    var tag = ""
    var timeString = ""
    
    class func parseNews(dict:NSDictionary) -> News {
        let news = News()
        
        news.id = dict["id"] as! Int
        news.title = dict["title"] as! String
        news.content = dict["content"] as! String
        news.tag = dict["tag"] as! String
        let time = (dict["create_time"] as! NSString).longLongValue
        
        let date = NSDate(timeIntervalSince1970: Double(time))
        let format = NSDateFormatter()
        format.dateFormat = "HH:mm"
        news.timeString = format.stringFromDate(date)
        
        return news
    }
}
