//
//  FileUtil.swift
//  Community
//
//  Created by Xinger on 15/3/28.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import Foundation

class FileUtil {
    
    class func getDefaultPath() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        return paths[0] as String
    }

    class func save(data:NSData, fileName:String) {
        var path = getDefaultPath()
        var savePath = path.stringByAppendingPathComponent(fileName)
        println("savePath = \(savePath)")
        
        data.writeToFile(savePath, atomically: true)
    }
    
    class func getUserImageFromLocal(user:User) -> UIImage? {
        var path = getDefaultPath().stringByAppendingPathComponent(user.getLocalImageName())
        var fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(path) {
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
}