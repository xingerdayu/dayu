//
//  ItemsView.swift
//  dayu
//
//  Created by Xinger on 15/8/31.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

protocol ReplyDelegate {
    func onReplyFinished(_: Reply)
}

class ItemsView: UIView, UIAlertViewDelegate {

    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var ivSupport: UIImageView!
    @IBOutlet weak var ivShit: UIImageView!
    @IBOutlet weak var tvSupportNum: UILabel!
    @IBOutlet weak var tvShitNum: UILabel!
    @IBOutlet weak var tvCommetNum: UILabel!
    
    var topic:Topic!
    var reply_reply:Reply?
    var replyDelegate:ReplyDelegate?
    
    func agreeOrDisagree(isSupport:Bool, success:(AnyObject!)->Void) {
        if app.isLogin() {
            let params = ["token":app.getToken(), "topicId": topic.id, "isSupport": "\(isSupport)"]
            
            HttpUtil.post(URLConstants.supportTopicUrl, params: params, success: success, failure: {(error:NSError!) in
                    print(error.localizedDescription)
                }, resultError: {(errorCode:String, errorText:String) in
                    ViewUtil.showToast(self, text: "您已经点过赞了", afterDelay: 1)
            })
        } else {
            ViewUtil.showToast(self, text: "请先登录", afterDelay: 1)
        }
    }
    
    @IBAction func support(sender: AnyObject) {
        agreeOrDisagree(true, success: {(response:AnyObject!) in
            print(response)
            self.ivSupport.highlighted = true
            self.topic.agreeCount += 1
            self.tvSupportNum.text = "\(self.topic.agreeCount)"
        })
    }
    
    @IBAction func disSupport(sender: AnyObject) {
        agreeOrDisagree(false, success: {(response:AnyObject!) in
            self.ivShit.highlighted = true
            self.topic.disagreeCount += 1
            self.tvShitNum.text = "\(self.topic.disagreeCount)"
        })
    }
    
    @IBAction func reply(sender: AnyObject) {
        if app.isLogin() {
            reply_reply = nil
            reply()
        } else {
            ViewUtil.showToast(self, text: "请先登录", afterDelay: 1)
        }
    }
    
    func reply() {
        let username = reply_reply == nil ? topic.username : reply_reply!.username
        let alertView = UIAlertView(title: "回复\(username):", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.delegate = self
        alertView.show()
    }
    
    func setTopicValue(topic:Topic) {
        self.topic = topic
        
        tvSupportNum.text = "\(topic.agreeCount)"
        tvCommetNum.text = "\(topic.replyCount)"
        tvShitNum.text = "\(topic.disagreeCount)"
        
        if topic.isSupport != nil {
            if topic.isSupport > 0 {
                ivSupport.highlighted = true
            } else {
                ivShit.highlighted = true
            }
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let contentText = alertView.textFieldAtIndex(0)!.text
            print(contentText)
            if contentText != nil {
                var params:NSDictionary!
                
                if reply_reply == nil {
                    params = ["token":app.getToken(), "username": app.user.getUsername(), "topicId":"\(topic.id)", "content":contentText!]
                } else {
                    params = ["token":app.getToken(), "username": app.user.getUsername(), "topicId":"\(topic.id)", "content":contentText!, "replyId":reply_reply!.id, "receiver":reply_reply!.username]
                }
                
                HttpUtil.post(URLConstants.addReplyUrl, params: params, success: {(response:AnyObject!) in
                    print(response)
                    
                    if response["stat"] as! String == "OK" {
                        ViewUtil.showToast(self, text: "回复发表成功", afterDelay: 1)
                        
                        self.topic.replyCount += 1
                        self.tvCommetNum.text = "\(self.topic.replyCount)"
                        
                        self.replyDelegate?.onReplyFinished(Reply.parseReply(response["reply"] as! NSDictionary))
                    }
                    
                    }, failure: {(error:NSError!) in
                        print(error.localizedDescription)
                })

            }
            
        }

    }
}
