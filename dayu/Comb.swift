//
//  Comb.swift
//  dayu
//
//  Created by 王毅东 on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

class Comb: NSObject {
    
    var createTime:Int64 = 0
    var drawdown:Float = 0.0
    var followNum = 0
    var grade = 0
    var gradego = 0
    var id = ""
    var name = ""
    
    var pro:Float = 0.0
    var situation:Int = 0
    var supportNum:Int  = 0
    var uid = ""
    var userName = ""
    var yesFollow = 0
    var yseSupport = 0
    
    var contentLabelWidth:CGFloat = 280
    var MAXFLOAT = 26;
    
    func parse(dict:NSDictionary) {
        var t: AnyObject? = dict["id"]
        id = "\(t)"
        createTime = (dict["create_time"] as NSString).longLongValue
        grade = dict["grade"] as Int
        drawdown = dict["drawdown"] as Float
        name = dict["name"] as String
        followNum = dict["follownum"] as Int
        gradego = dict["gradego"] as Int
        pro = dict["pro"] as Float
        situation = dict["situation"] as Int
        supportNum = dict["supportnum"] as Int
        uid = dict["uid"] as String
        userName = dict["username"] as String
        yesFollow = dict["yesfollow"] as Int
        yseSupport = dict["yessupport"] as Int
    }
    
//    func getNameWidth() -> CGFloat {
//        var size = name.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(20000, 22))
////        CGSize titleSize = [aString sizeWithFont,font constrainedToSize:CGSizeMake(MAXFLOAT, 30)]
////        if imageNum > 0 {
////            imageGroupHeight = defaultImageGroupHeight
////        }
////        var text: NSString = NSString(CString: name.cStringUsingEncoding(NSUTF8StringEncoding)!,
////            encoding: NSUTF8StringEncoding)
////        text.sizeWithAttributes(attrs: [NSObject : AnyObject]!)
//        
//        return contentLabelOffsetY + size.height + imageGroupHeight + marginTop * 3 + 30
//    }
    
    func getColor(s: Int, g: Int) -> [String] {
        var colors = [String](count: 4, repeatedValue: "")
        if s < 20 {
            colors[0] = "comb_circle_1"
            colors[1] = g > 0 ? "comb_up_1" : "comb_down_1"
            colors[2] = "#999999"
        } else if s < 40 {
            colors[0] = "comb_circle_2"
            colors[1] = g > 0 ? "comb_up_2" : "comb_down_2"
            colors[2] = "#397ada"
        } else if s < 60 {
            colors[0] = "comb_circle_3"
            colors[1] = g > 0 ? "comb_up_3" : "comb_down_3"
            colors[2] = "#44b74f"
        } else if s < 80 {
            colors[0] = "comb_circle_4"
            colors[1] = g > 0 ? "comb_up_4" : "comb_down_4"
            colors[2] = "#fda126"
        } else {
            colors[0] = "comb_circle_5"
            colors[1] = g > 0 ? "comb_up_5" : "comb_down_5"
            colors[2] = "#ef5a3a"
        }
        return colors
    }
}