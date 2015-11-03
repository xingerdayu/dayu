//
//  MessageViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/9.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class MessageViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    //var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
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
        
        let m_message = messageList[indexPath.row] as! Message
        
        switch m_message.msgType {
        case MessageType.JOIN_GROUP:
            groupMessage = m_message
            if m_message.isHandle {
                ViewUtil.showToast(self.view, text: "您已经处理过该消息", afterDelay: 2)
            } else {
                let alertView = UIAlertView(title: "是否同意\(m_message.username)加入该圈子?", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
                alertView.show()
            }
        case MessageType.ADJUST:
            print("Adjust \(m_message.attachId)")
            let params = ["cid": m_message.attachId]
            HttpUtil.post(URLConstants.getCombinationInfoUrl, params: params, success: {(response:AnyObject!) in
                //print(response)
                let comb = Comb()
                comb.parse(response["combinations"] as! NSDictionary)
                let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc = usb.instantiateViewControllerWithIdentifier("CombDetailViewController") as! CombDetailViewController
                vc.comb = comb
                self.navigationController?.pushViewController(vc, animated: true)
             })
        case MessageType.SYSTEM:
            //TODO 处理系统消息
            print("系统消息")
        default:
            let topicId = m_message.attachId
            toTopicActivity(topicId)
        }
    }
    
    func toTopicActivity(topicId:Int) {
        let params = ["token":app.getToken(), "id":topicId]
        HttpUtil.post(URLConstants.getTopicUrl, params: params, success: {(response:AnyObject!) in
            let topic = Topic.parseTopic(response["topic"] as! NSDictionary)
            let usb = UIStoryboard(name: "Group", bundle: NSBundle.mainBundle())
            let replyVc = usb.instantiateViewControllerWithIdentifier("ReplyListControllerUI") as! ReplyListViewController
            replyVc.topic = topic
            self.navigationController?.pushViewController(replyVc, animated: true)
        })
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let params = ["token":app.getToken(), "userId":groupMessage.sendId, "groupId":groupMessage.attachId]
            HttpUtil.post(URLConstants.agreeJoinGroupUrl, params: params,
                success: {(response:AnyObject!) in
                    self.groupMessage.isHandle = true
                    ViewUtil.showToast(self.view, text: "已同意\(self.groupMessage.username)加入该圈子", afterDelay: 2)
                }, failure: {(error:NSError!) in
                    print(error.description)
                }, resultError: {(errorCode:String, errorText:String) in
                    ViewUtil.showToast(self.view, text: "已处理过该消息", afterDelay: 2)
            })
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as UITableViewCell
        
        let m_message = messageList[indexPath.row] as! Message
        
        let bgView = cell.viewWithTag(50)!
        let photoIv = cell.viewWithTag(51) as! UIImageView
        let nameLabel = cell.viewWithTag(52) as! UILabel
        let timeLabel = cell.viewWithTag(53) as! UILabel
        let titleLabel = cell.viewWithTag(54) as! UILabel
        let contentLabel = cell.viewWithTag(55) as! UILabel
        
        photoIv.clipsToBounds = true
        photoIv.layer.cornerRadius = 20
        photoIv.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(m_message.sendId)), placeholderImage:UIImage(named: "user_default_photo.png"))
        
        nameLabel.text = m_message.username
        timeLabel.text = StringUtil.fitFormatTime(m_message.createTime)
        titleLabel.text = m_message.title
        contentLabel.text = m_message.content
        
        //contentLabel.translatesAutoresizingMaskIntoConstraints = true //清除 AutoLayout的影响
        //bgView.translatesAutoresizingMaskIntoConstraints = true //清除 AutoLayout的影响
        
        let clWidth = 280 * app.autoSizeScaleX
        let size = m_message.content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(clWidth, 20000));
        let frame = contentLabel.frame
        contentLabel.frame = CGRectMake(10 * app.autoSizeScaleX, frame.origin.y, clWidth, size.height)
        bgView.frame = CGRectMake(10 * app.autoSizeScaleX, bgView.frame.origin.y, 300 * app.autoSizeScaleX, 95 + size.height)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let m_message = messageList[indexPath.row] as! Message
        let size = m_message.content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(280 * app.autoSizeScaleX, 20000));
        
        return 105 + size.height
    }
    
    func getUserMessages() {
        let params = ["token": app.getToken(), "readStat": 2]
        HttpUtil.post(URLConstants.getMessagesUrl, params: params, success: {(response:AnyObject!) in
            //println(response)
            if response["stat"] as! String == "OK" {
                var count = 0
                let array = response["messages"] as! NSArray
                
                //var list = NSMutableArray()
                for item in array {
                    let message = Message.parseMessage(item as! NSDictionary)
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
        let msg = messageList[indexPath.row] as! Message
        deleteMessage(msg)
    }
    
    func deleteMessage(msg:Message) {
        let params = ["token":app.getToken(), "msgId":msg.id]
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
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }

}
