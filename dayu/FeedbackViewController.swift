//
//  FeedbackViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/9.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseUIViewController, UITextViewDelegate {

    var isEmpty = true
    @IBOutlet weak var utfFeedback: UITextView!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var utfContact: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initFeedback()
        utfFeedback.layer.borderColor = Colors.MyLightGrayColor.CGColor
        utfFeedback.layer.borderWidth = 1
        utfFeedback.layer.masksToBounds = true
        
        bgView.layer.borderColor = Colors.MyLightGrayColor.CGColor
        bgView.layer.borderWidth = 1
        bgView.layer.masksToBounds = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        utfFeedback.resignFirstResponder()
        utfContact.resignFirstResponder()
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if isEmpty {
            utfFeedback.text = ""
            utfFeedback.textColor = UIColor.blackColor()
            isEmpty = false
        }
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if utfFeedback.text.isEmpty {
            initFeedback()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        changeLength()
    }
    
    func changeLength() {
        var length = (utfFeedback.text as NSString).length
        wordLabel.text = "\(length)/150"
    }

    @IBAction func submit(sender: UIButton) {
        if utfFeedback.text.isEmpty {
            ViewUtil.showAlertView("反馈内容不能为空!", view: self)
            return
        }
        var params = ["token":app.getToken(), "contact":utfContact.text, "content":utfFeedback.text]
        
        HttpUtil.post(URLConstants.suggestUrl, params: params, success: {(response:AnyObject!) in
            if (response["stat"] as String) == "OK" {
                self.initFeedback()
                self.changeLength()
                ViewUtil.showToast(self.view, text: "您的意见我们已经收到,谢谢支持！", afterDelay: 1)
            }
            }, failure: {(error:NSError!) in
                println(error.localizedDescription)
        })
    }
    
    func initFeedback() {
        utfFeedback.text = "您的意见将会帮助我们更好的改进"
        utfFeedback.textColor = UIColor.grayColor()
        isEmpty = true
    }
}
