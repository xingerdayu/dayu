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
    
    func setTopic(topic:Topic) {
        lbTime.text = topic.timeString
        lbName.text = topic.username
        
        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(topic.userId)), placeholderImage:UIImage(named: "user_default_photo.png"))
        
        ivPhoto.layer.cornerRadius = 20
        ivPhoto.clipsToBounds = true
        
        var contentLabel = ViewUtil.createLabelByString(topic.content, x: topic.contentLabelOffsetX, y: topic.contentLabelOffsetY, width: topic.contentLabelWidth)
        topic.contentLabelHeight = contentLabel.frame.size.height
        
        self.addSubview(contentLabel)
        
        if topic.imageNum > 0 {
            topic.imageGroupHeight = topic.defaultImageGroupHeight
            var imageGroupView = createGroupImageView(topic, offsetY: topic.contentLabelHeight)
            self.addSubview(imageGroupView)
        }

        topic.contentHeight = topic.contentLabelOffsetY + topic.contentLabelHeight + topic.imageGroupHeight + topic.marginTop * 3
        bgView.frame = CGRectMake(10, 5, 300, topic.contentHeight - 10)
        self.frame = CGRectMake(0, 0, 320, topic.contentHeight)
    }
    
    func createGroupImageView(topic:Topic, offsetY:CGFloat) -> UIView {
        var imageGroupView = UIView(frame: CGRectMake(0, topic.contentLabelOffsetY + offsetY + topic.marginTop, 320, 80))
        imageGroupView.tag = 11
        for var i = 0; i < topic.imageNum; i++ {
            var imageView = UIImageView(frame: CGRectMake(CGFloat(20 + i * 65), 5, 60, 60))
            imageView.sd_setImageWithURL(NSURL(string: URLConstants.getTopicImageUrl(topic, i: i)))
            imageGroupView.addSubview(imageView)
        }
        return imageGroupView
    }

}
