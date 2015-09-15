//
//  HttpUtil.swift
//  Community
//
//  Created by Xinger on 15/3/14.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

//
//  HttpUtil.swift
//  SucunCloudV2
//
//  Created by 冯鹏举 on 14/11/23.
//  Copyright (c) 2014年 com.cloudhua. All rights reserved.
//

import Foundation

let DATA_WRITE_LENGTH = 4 * 1024 * 1024

class HttpUtil {
    
    class func post(url:String, params:NSDictionary, success:(AFHTTPRequestOperation!, AnyObject!)->Void, failure:(AFHTTPRequestOperation!, NSError!)->Void) {
        var manager = AFHTTPRequestOperationManager()
        manager.POST(url, parameters: params, success: success, failure: failure)
    }
    
    class func post(url:String, params:NSDictionary, success:(AnyObject!)->Void) {
//        var manager = AFHTTPRequestOperationManager()
//        manager.POST(url, parameters: params, success: {(AFHTTPRequestOperation, response:AnyObject!) in
//            if response["stat"] as String == "OK" {
//                success(response)
//            }
//            }, failure: {(AFHTTPRequestOperation, error:NSError!) in
//                println(error.localizedDescription)
//        })
        post(url, params: params, success: success, failure: {(error:NSError!) in
            println(error.localizedDescription)
        })
    }
    
    class func post(url:String, params:NSDictionary, success:(AnyObject!)->Void, failure:(NSError!) -> Void) {
//        var manager = AFHTTPRequestOperationManager()
//        manager.POST(url, parameters: params, success: {(AFHTTPRequestOperation, response:AnyObject!) in
//            if response["stat"] as String == "OK" {
//                success(response)
//            }
//            }, failure: {(AFHTTPRequestOperation, error:NSError!) in
//                failure(error)
//        })
        post(url, params: params, success: success, failure: failure, resultError: {(errorCode:String, errorText:String) in
            println("errorCode = \(errorCode), errorText = \(errorText)")
        })
    }
    
    class func post(url:String, params:NSDictionary, success:(AnyObject!)->Void, failure:(NSError!) -> Void, resultError:(String, String) -> Void) {
        var manager = AFHTTPRequestOperationManager()
        manager.POST(url, parameters: params, success: {(AFHTTPRequestOperation, response:AnyObject!) in
            if response["stat"] as String == "OK" {
                success(response)
            } else {
                resultError(response["stat"] as String, response["errText"] as String)
            }
            }, failure: {(AFHTTPRequestOperation, error:NSError!) in
                failure(error)
        })
    }
    
    class func get(url:String, success:(AnyObject!)->Void) {
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url, parameters: nil, success: {(AFHTTPRequestOperation, response:AnyObject!) in
                success(response)
            }, failure: {(AFHTTPRequestOperation, error:NSError!) in
                println(error.localizedDescription)
        })
    }
    
    class func post(url:String, params:NSDictionary, imageData:[NSData], success:(AnyObject!)->Void, failure:(NSError)->Void) {
//        var manager = AFHTTPRequestOperationManager()
//        manager.POST(url, parameters: params, constructingBodyWithBlock: {(data:AFMultipartFormData!) in
//            for var i=0; i<imageData.count; i++ {
//                data.appendPartWithFileData(imageData[i], name: "file\(i)", fileName: "image\(i).jpg", mimeType: "image/jpg")
//            }
//            }, success: {(AFHTTPRequestOperation, response:AnyObject!) in
//                if response["stat"] as String == "OK" {
//                    success(response)
//                }
//            }, failure: {(AFHTTPRequestOperation, error:NSError!) in
//                failure(error)
//        })
        post(url, params: params, imageData: imageData, success: success, failure: failure, resultError:{(errorCode:String, errorText:String) in
            println("errorCode = \(errorCode), errorText = \(errorText)")
        })
    }

    class func post(url:String, params:NSDictionary, imageData:[NSData], success:(AnyObject!)->Void, failure:(NSError)->Void, resultError:(String, String) -> Void) {
        var manager = AFHTTPRequestOperationManager()
        manager.POST(url, parameters: params, constructingBodyWithBlock: {(data:AFMultipartFormData!) in
            for var i=0; i<imageData.count; i++ {
                data.appendPartWithFileData(imageData[i], name: "file\(i)", fileName: "image\(i).jpg", mimeType: "image/jpg")
            }
            }, success: {(AFHTTPRequestOperation, response:AnyObject!) in
                if response["stat"] as String == "OK" {
                    success(response)
                } else {
                    resultError(response["stat"] as String, response["errText"] as String)
                }
            }, failure: {(AFHTTPRequestOperation, error:NSError!) in
                failure(error)
        })
    }
}