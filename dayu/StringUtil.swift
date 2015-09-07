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
    class func formatTime(time:Int64) -> NSString {
        var date = NSDate(timeIntervalSince1970: Double(time))
        var format = NSDateFormatter()
        format.dateFormat = "yyyy/MM/dd"
        var stringDate = format.stringFromDate(date)
        return stringDate
    }
    
    class func formatFloat(f:Float) -> String {
        var str = NSString(format: "%.02lf", f)
        if str.length > 5 {
            str = str.substringToIndex(5)
        }
        return str
    }
    
    class func colorWithHexString (hex:String)-> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(advance(cString.startIndex, 1))
        }
        
        if (countElements(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rString = cString.substringToIndex(advance(cString.startIndex, 2))
        var gString = cString.substringFromIndex(advance(cString.startIndex, 2)).substringToIndex(advance(cString.startIndex, 2))
        var bString = cString.substringFromIndex(advance(cString.startIndex, 4)).substringToIndex(advance(cString.startIndex, 2))
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner.scannerWithString(rString).scanHexInt(&r)
        NSScanner.scannerWithString(gString).scanHexInt(&g)
        NSScanner.scannerWithString(bString).scanHexInt(&b)
        return UIColor(red: CGFloat(r) / 255.0, green:CGFloat(g) / 255.0, blue:CGFloat(b) / 255.0, alpha:CGFloat(1))
    }


}