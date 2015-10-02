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
    
    var shouldShowItems = true
    var shouldShowCommentLabel = false
    
    func setTopic(topic:Topic) {
        lbTime.text = topic.timeString as String
        lbName.text = topic.username
        
        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(topic.userId)), placeholderImage:UIImage(named: "user_default_photo.png"))
        
        ivPhoto.layer.cornerRadius = 20
        ivPhoto.clipsToBounds = true //照片切圆角
        
        let clWidth = self.getContentLabelWidth(topic)
        let contentLabel = ViewUtil.createLabelByString(topic.content, x: topic.contentLabelOffsetX, y: topic.contentLabelOffsetY, width: clWidth)
        contentLabel.textColor = Colors.LargeBlackColor
        topic.contentLabelHeight = contentLabel.frame.size.height  //根据文字的长度与Label的宽度计算Label的高度
        
        self.addSubview(contentLabel)
        
        if topic.imageNum > 0 { //生成帖子的图片
            topic.imageGroupHeight = topic.defaultImageGroupHeight
            let imageGroupView = createGroupImageView(topic, offsetY: topic.contentLabelHeight)
            self.addSubview(imageGroupView)
        }
        
        topic.contentHeight = topic.contentLabelOffsetY + topic.contentLabelHeight + topic.imageGroupHeight + topic.marginTop * 3 /**这里有3个组的高度想家，所以加入3个向上的间距 **/
        if shouldShowItems { //是否显示点赞，评论等按钮
            topic.contentHeight = topic.contentHeight + 30
        }
        if shouldShowCommentLabel { //是否显示评论按钮
            let commentLabel = UILabel(frame: CGRectMake(10, topic.contentHeight - 20, clWidth, 20))
            commentLabel.font = UIFont(name: "Arial", size: 12.0)
            commentLabel.text = "评论(\(topic.replyCount))"
            commentLabel.textColor = Colors.ReplyContentColor
            bgView.addSubview(commentLabel)
            topic.contentHeight = topic.contentHeight + 10
        }
        modifyBgViewSize(topic)
        self.frame = CGRectMake(0, 0, 320, topic.contentHeight)
    }
    
    func createGroupImageView(topic:Topic, offsetY:CGFloat) -> UIView {
        let imageGroupView = UIView(frame: CGRectMake(0, topic.contentLabelOffsetY + offsetY + topic.marginTop, 320, 80))
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
    
    func getContentLabelWidth(topic:Topic) -> CGFloat {
        return topic.contentLabelWidth
    }
    
    func modifyBgViewSize(topic:Topic) {
        if shouldShowCommentLabel {
           bgView.backgroundColor = UIColor.clearColor()
        } else {
            bgView.frame = CGRectMake(10, 5, 300, topic.contentHeight - 10)
        }
    }

}
