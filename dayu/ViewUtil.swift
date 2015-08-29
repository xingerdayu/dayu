//
//  ViewUtil.swift
//  Community
//
//  Created by Xinger on 15/3/15.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//
class ViewUtil {
    
    class func showAlertView(title:String, view:UIViewController) {
        UIAlertView(title: title, message: "", delegate: view, cancelButtonTitle: "取消").show()
    }
    
    class func showAlertView(title:String, message:String, view:UIViewController) {
        UIAlertView(title: title, message: message, delegate: view, cancelButtonTitle: "取消").show()
    }
    
    class func showToast(view:UIView, text:String, afterDelay:NSTimeInterval) {
        var toast = MBProgressHUD.showHUDAddedTo(view, animated: true)
        toast.mode = MBProgressHUDModeText
        toast.labelText = text
        toast.margin = 10.0
        toast.removeFromSuperViewOnHide = true
        toast.hide(true, afterDelay: afterDelay)
    }
    
}
