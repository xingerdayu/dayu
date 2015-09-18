//
//  MessageViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/9.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class MessageViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    var messageList = NSMutableArray()
    var groupMessage:Message!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        getUserMessages()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var m_message = messageList[indexPath.row] as Message
        
        switch m_message.msgType {
        case MessageType.JOIN_GROUP:
            groupMessage = m_message
            if m_message.isHandle {
                ViewUtil.showToast(self.view, text: "您已经处理过该消息", afterDelay: 2)
            } else {
                var alertView = UIAlertView(title: "是否同意\(m_message.username)加入该圈子?", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alertView.show()
            }
        case MessageType.ADJUST:
            //调仓消息，等待东哥那边处理
            println("Adjust \(m_message.attachId)")
            var params = ["cid": m_message.attachId]
            HttpUtil.post(URLConstants.getCombinationInfoUrl, params: params, success: {(response:AnyObject!) in
                println(response)
                var comb = Comb()
                comb.parse(response["combinations"] as NSDictionary)
                var usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                var vc = usb.instantiateViewControllerWithIdentifier("CombDetailViewController") as CombDetailViewController
                vc.comb = comb
                self.navigationController?.pushViewController(vc, animated: true)
             })
        case MessageType.SYSTEM:
            //TODO 处理系统消息
            println("系统消息")
        default:
            var topicId = m_message.attachId
            toTopicActivity(topicId)
        }
    }
    
    func toTopicActivity(topicId:Int) {
        var params = ["token":app.getToken(), "id":topicId]
        HttpUtil.post(URLConstants.getTopicUrl, params: params, success: {(response:AnyObject!) in
            var topic = Topic.parseTopic(response["topic"] as NSDictionary)
            var usb = UIStoryboard(name: "Group", bundle: NSBundle.mainBundle())
            var replyVc = usb.instantiateViewControllerWithIdentifier("ReplyListControllerUI") as ReplyListViewController
            replyVc.topic = topic
            self.navigationController?.pushViewController(replyVc, animated: true)
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var params = ["token":app.getToken(), "userId":groupMessage.sendId, "groupId":groupMessage.attachId]
            HttpUtil.post(URLConstants.agreeJoinGroupUrl, params: params,
                success: {(response:AnyObject!) in
                    self.groupMessage.isHandle = true
                    ViewUtil.showToast(self.view, text: "已同意\(self.groupMessage.username)加入该圈子", afterDelay: 2)
                }, failure: {(error:NSError!) in
                    println(error.description)
                }, resultError: {(errorCode:String, errorText:String) in
                    ViewUtil.showToast(self.view, text: "已处理过该消息", afterDelay: 2)
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as UITableViewCell
        
        var m_message = messageList[indexPath.row] as Message
        
        var bgView = cell.viewWithTag(50)!
        var photoIv = cell.viewWithTag(51) as UIImageView
        var nameLabel = cell.viewWithTag(52) as UILabel
        var timeLabel = cell.viewWithTag(53) as UILabel
        var titleLabel = cell.viewWithTag(54) as UILabel
        var contentLabel = cell.viewWithTag(55) as UILabel
        
        photoIv.clipsToBounds = true
        photoIv.layer.cornerRadius = 20
        photoIv.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(m_message.sendId)), placeholderImage:UIImage(named: "user_default_photo.png"))
        
        nameLabel.text = m_message.username
        timeLabel.text = StringUtil.fitFormatTime(m_message.createTime)
        titleLabel.text = m_message.title
        contentLabel.text = m_message.content
        
        contentLabel.setTranslatesAutoresizingMaskIntoConstraints(true) //清除 AutoLayout的影响
        bgView.setTranslatesAutoresizingMaskIntoConstraints(true) //清除 AutoLayout的影响
        
        var size = m_message.content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(280, 20000));
        var frame = contentLabel.frame
        contentLabel.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, size.height)
        bgView.frame = CGRectMake(bgView.frame.origin.x, bgView.frame.origin.y, bgView.frame.width, 95 + size.height)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var m_message = messageList[indexPath.row] as Message
        var size = m_message.content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(280, 20000));
        
        return 105 + size.height
    }
    
    func getUserMessages() {
        var params = ["token": app.getToken(), "readStat": 2]
        HttpUtil.post(URLConstants.getMessagesUrl, params: params, success: {(response:AnyObject!) in
            //println(response)
            if response["stat"] as String == "OK" {
                var count = 0
                var array = response["messages"] as NSArray
                
                //var list = NSMutableArray()
                for item in array {
                    var message = Message.parseMessage(item as NSDictionary)
                    self.messageList.addObject(message) //这里的消息可能以后要存入数据库
                    
                    if message.status == 0 {
                        count++ //计算未读消息的记录
                    }
                }
                self.myTableView.reloadData()
            }
        })
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.setEditing(false, animated: true)
        var msg = messageList[indexPath.row] as Message
        deleteMessage(msg)
    }
    
    func deleteMessage(msg:Message) {
        var params = ["token":app.getToken(), "msgId":msg.id]
        HttpUtil.post(URLConstants.deleteMessageUrl, params: params, success: {(response:AnyObject!) in
            self.messageList.removeObject(msg)
            self.myTableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //设置滑动出来的样式,还有Insert
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String! {
        return "删除"
    }

}
