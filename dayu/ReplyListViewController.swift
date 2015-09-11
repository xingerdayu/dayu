//
//  ReplyListViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/3.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class ReplyListViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource, OnBackListener, ReplyDelegate {
    
    var topic:Topic! //这个topic必须传入
    var replyList = NSMutableArray()
    var itemsView:ItemsView2!
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        myTableView.tableHeaderView = createHeaderView()
        
        getReplyList()
        
        itemsView = NSBundle.mainBundle().loadNibNamed("ItemsView2", owner: self, options: nil)[0] as ItemsView2
        itemsView.frame = CGRectMake(0, 528, 320, 40)
        itemsView.backDelegete = self
        itemsView.replyDelegate = self
        itemsView.setTopic(topic)
        self.view.addSubview(itemsView)
    }
    
    func onBack() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onReplyFinished(reply:Reply) {
        self.replyList.addObject(reply)
        self.myTableView.reloadData()
        
        self.myTableView.scrollToNearestSelectedRowAtScrollPosition(UITableViewScrollPosition.Bottom, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var reply = replyList[indexPath.row] as Reply
        
        var cell = tableView.dequeueReusableCellWithIdentifier("ReplyCell", forIndexPath: indexPath) as UITableViewCell
        
        var ivPhoto = cell.viewWithTag(31) as UIImageView
        var lbTime = cell.viewWithTag(32) as UILabel
        var lbName = cell.viewWithTag(33) as UILabel
        cell.viewWithTag(34)?.removeFromSuperview()
        
        lbTime.text = reply.timeString
        lbName.text = reply.username
        
        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(reply.userId)), placeholderImage:UIImage(named: "user_default_photo.png"))
        ivPhoto.layer.cornerRadius = 20
        ivPhoto.clipsToBounds = true
        
        var contentLable:UILabel!
        if reply.receiver != nil {
            var str = NSString(string:"回复\(reply.receiver!)：")
            var range = NSMakeRange(0, str.length)
            var attrContent = NSMutableAttributedString(string: reply.content)
            attrContent.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: range)
            attrContent.addAttribute(NSFontAttributeName, value: UIFont(name: "Arial", size: 14.0), range: range)
            contentLable = ViewUtil.createLabelByString(reply.content, x: 20, y: 55, width: 280, attrContent:attrContent)
        } else {
            contentLable = ViewUtil.createLabelByString(reply.content, x: 20, y: 55, width: 280)
        }
        contentLable.textColor = Colors.ReplyContentColor
        contentLable.tag = 34
        cell.addSubview(contentLable)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var reply = replyList[indexPath.row] as Reply
        var size = reply.content.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(300, 20000));
        return (65 + size.height)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        itemsView.reply_reply = replyList[indexPath.row] as? Reply
        
        itemsView.reply()
    }
    
    func createHeaderView() -> UIView {
        var topicView = NSBundle.mainBundle().loadNibNamed("TopicView", owner: self, options: nil)[0] as TopicView
        topicView.shouldShowItems = false
        topicView.shouldShowCommentLabel = true
        topicView.setTopic(topic)
        return topicView
    }


    func getReplyList() {
        var params = ["token":app.getToken(), "topicId":topic.id]
        
        self.replyList.removeAllObjects()
        
        HttpUtil.post(URLConstants.getReplysUrl, params: params, success: {(response:AnyObject!) in
            println(response)
            if response["stat"] as String == "OK" {
                self.parseReply(response)
            }
            }, failure: {(error:NSError!) in
                println(error.localizedDescription)
        })
    }
    
    func parseReply(response:AnyObject!) {
        var array = response["replys"] as NSArray
        for item in array {
            var reply = Reply.parseReply(item as NSDictionary)
            self.replyList.addObject(reply)
        }
        self.myTableView.reloadData()
        
//        if self.shouldScrollToBottom {
//            self.myTableView.scrollToNearestSelectedRowAtScrollPosition(UITableViewScrollPosition.Bottom, animated: true)
//        }
    }


}
