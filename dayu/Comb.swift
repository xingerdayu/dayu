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
    
    func parse(dict:NSDictionary) {
        id = dict["id"] as String
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
    
}