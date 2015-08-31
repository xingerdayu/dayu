//
//  ViewUtil.swift
//  Community
//
//  Created by Xinger on 15/3/15.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

let FONT_SIZE:CGFloat = 15.0

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
    
    class func createLabel(content:NSString, x:CGFloat, y:CGFloat, width:CGFloat) -> UILabel {
        var contentLabel = UILabel()
        contentLabel.tag = 33
        var size = content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(width, 20000));
        contentLabel.font = UIFont.systemFontOfSize(FONT_SIZE)
        contentLabel.sizeToFit()
        contentLabel.frame = CGRectMake(x, y, size.width, CGFloat(Int(size.height + 1)))
        contentLabel.numberOfLines = 0
        return contentLabel
    }
    
    /**根据字符串长度生适合String高度的UILabel**/
    class func createLabelByString(content:NSString, x:CGFloat, y:CGFloat, width:CGFloat) -> UILabel {
        var contentLabel = createLabel(content, x: x, y: y, width: width)
        contentLabel.text = content
        return contentLabel
    }
    
    class func createLabelByString(content:NSString, x:CGFloat, y:CGFloat, width:CGFloat, attrContent:NSAttributedString) -> UILabel {
        var contentLabel = createLabel(content, x: x, y: y, width: width)
        contentLabel.attributedText = attrContent
        return contentLabel
    }

    
}
