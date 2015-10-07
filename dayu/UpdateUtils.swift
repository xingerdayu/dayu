//
//  UpdateUtils.swift
//  dayu
//
//  Created by Xinger on 15/10/6.
//  Copyright © 2015年 Xinger. All rights reserved.
//

import Foundation

class UpdateUtils {
    class func checkUpdate(delegate:UIAlertViewDelegate, isNew:()->Void) {
        print(String(format: "http://itunes.apple.com/lookup?id=%d", kStoreAppId))
        let infoDict = NSBundle.mainBundle().infoDictionary!;
        let currentVersion = infoDict["CFBundleVersion"] as! String
        let url = NSURL(string: String(format: "http://itunes.apple.com/lookup?id=%d", kStoreAppId))
        
        let request = NSURLRequest(URL: url!)
        
        var jsonData:NSDictionary?
        do {
            let response = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            
            jsonData = try NSJSONSerialization.JSONObjectWithData(response, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        } catch {
            print("error get the new version")
        }
        
        let infoArray = jsonData?.objectForKey("results") as? NSArray
        if infoArray?.count != 0 {
            let releaseInfo = infoArray?[0] as! NSDictionary
            
            let lastVersion : NSString = releaseInfo["version"] as! NSString
            
            if ((NSString(string: currentVersion)).floatValue < lastVersion.floatValue){
                let alertView = UIAlertView(title: "更新", message: "有新版本更新，是否前往更新？", delegate: delegate, cancelButtonTitle: "关闭", otherButtonTitles: "更新")
                alertView.tag = 10000
                alertView.show()
            }
        } else {
            isNew()
        }
        
    }

}