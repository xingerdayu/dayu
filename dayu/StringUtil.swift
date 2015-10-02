//
//  StringUtil.swift
//  Community
//
//  Created by Xinger on 15/3/19.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import Foundation

class StringUtil {
    
    class func getValue(value:NSNumber?) -> NSNumber {
        if value != nil {
            return value!
        }
        return NSNumber(int: 0)
    }
    
    class func getFloatValue(value:Float?) -> String {
        if value != nil {
            return StringUtil.formatFloat(value! * 100)
        }
        return "0"
    }
    
    class func getStringValue(value:String?) -> String {
        if value != nil {
            return value!
        }
        return ""
    }
    
    //格式化时间
    class func formatTime(time:Int64) -> String {
        let date = NSDate(timeIntervalSince1970: Double(time))
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let stringDate = format.stringFromDate(date)
        return stringDate
    }
    
    class func formatFloat(f:Float) -> String {
        var str = NSString(format: "%.02lf", f)
        if str.length > 5 {
            str = str.substringToIndex(5)
        }
        return str as String
    }
    
    //格式化时间
    class func fitFormatTime(time:Int64) -> String {
        let current = Int64(NSDate().timeIntervalSince1970)
        let pTime = (current - time) / 60
        if pTime < 0 {
            return "刚刚"
        } else if pTime < 60 {
            return "\(pTime)分钟前"
        } else if pTime / 60 < 24 {
            return "\(pTime / 60)小时前"
        } else {
            return formatTime(time)
        }
    }
    
    class func colorWithHexString (hex:String)-> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if (cString.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 6) {
            return UIColor.grayColor()
        }
        
        let rString = cString.substringToIndex(cString.startIndex.advancedBy(2))
        let gString = cString.substringFromIndex(cString.startIndex.advancedBy(2)).substringToIndex(cString.startIndex.advancedBy(2))
        let bString = cString.substringFromIndex(cString.startIndex.advancedBy(4)).substringToIndex(cString.startIndex.advancedBy(2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        //NSScanner.scannerWithString(rString).scanHexInt(&r)
        //NSScanner.scannerWithString(gString).scanHexInt(&g)
        //NSScanner.scannerWithString(bString).scanHexInt(&b)
        return UIColor(red: CGFloat(r) / 255.0, green:CGFloat(g) / 255.0, blue:CGFloat(b) / 255.0, alpha:CGFloat(1))
    }


}