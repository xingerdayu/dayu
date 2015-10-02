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
        let path = getDefaultPath()
        let savePath = NSURL(string: path)?.URLByAppendingPathComponent(fileName)//.stringByAppendingPathComponent(fileName)
        print("savePath = \(savePath)")
        
        data.writeToURL(savePath!, atomically: true)
        //data.writeToFile(savePath, atomically: true)
    }
    
    class func getUserImageFromLocal(user:User) -> UIImage? {
        //let path = getDefaultPath().stringByAppendingPathComponent(user.getLocalImageName())
        let path = NSURL(string: getDefaultPath())?.URLByAppendingPathComponent(user.getLocalImageName()).absoluteString
        let fileManager = NSFileManager.defaultManager()
        
        if !fileManager.fileExistsAtPath(path!) {
            return nil
        }
        return UIImage(contentsOfFile: path!)
    }
}