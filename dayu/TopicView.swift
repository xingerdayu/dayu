//
//  TopicView.swift
//  dayu
//
//  Created by Xinger on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class TopicView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbName: UILabel!
    
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var shouldShowItems = true
    var shouldShowCommentLabel = false
    
    func setTopic(topic:Topic) {
        lbTime.text = topic.timeString as String
        lbName.text = topic.username
        
        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(topic.userId)), placeholderImage:UIImage(named: "user_default_photo.png"))
        
        ivPhoto.layer.cornerRadius = 20
        ivPhoto.clipsToBounds = true //照片切圆角
        
        let contentLabel = ViewUtil.createLabelByString(topic.content, x: topic.getContentOffsetX(), y: topic.getContentOffsetY(), width: topic.getContentWidth())
        contentLabel.textColor = Colors.LargeBlackColor
        
        self.addSubview(contentLabel)
        
        if topic.imageNum > 0 { //生成帖子的图片
            let imageGroupView = createGroupImageView(topic)
            self.addSubview(imageGroupView)
        }
        
//        if shouldShowCommentLabel { //是否显示评论按钮
//            let commentLabel = UILabel(frame: CGRectMake(10, topic.getImageOffsetY() - 20, topic.getContentWidth(), 20))
//            commentLabel.font = UIFont(name: "Arial", size: 12.0)
//            commentLabel.text = "评论(\(topic.replyCount))"
//            commentLabel.textColor = Colors.ReplyContentColor
//            bgView.addSubview(commentLabel)
//        }
        modifyBgViewSize(topic)
        self.frame = CGRectMake(0, 0, 320 * app.autoSizeScaleX, topic.getAllHeight(shouldShowItems) + 10)
    }
    
    func createGroupImageView(topic:Topic) -> UIView {
        let imageGroupView = UIView(frame: CGRectMake(0, topic.getImageOffsetY(), 320 * app.autoSizeScaleX, 80))
        imageGroupView.tag = 11
        for var i = 0; i < topic.imageNum; i++ {
            let imageView = UIImageView(frame: getImageGroupFrame(i))
            imageView.sd_setImageWithURL(NSURL(string: URLConstants.getTopicImageUrl(topic, i: i)))
            imageGroupView.addSubview(imageView)
        }
        return imageGroupView
    }
    
    func getImageGroupFrame(i:Int) -> CGRect {
        return CGRectMake(CGFloat(20 + i * 65), 5, 60, 60)
    }
    
    func modifyBgViewSize(topic:Topic) {
        if shouldShowCommentLabel {
            bgView.backgroundColor = UIColor.clearColor()
        } else {
            bgView.frame = CGRectMake(10, 5, 300 * app.autoSizeScaleX, topic.getAllHeight(shouldShowItems))
        }
    }

}
