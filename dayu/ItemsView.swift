//
//  ItemsView.swift
//  dayu
//
//  Created by Xinger on 15/8/31.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class ItemsView: UIView {

    @IBOutlet weak var ivSupport: UIImageView!

    @IBOutlet weak var ivShit: UIImageView!

    @IBOutlet weak var tvSupportNum: UILabel!
    
    @IBOutlet weak var tvShitNum: UILabel!
    
    @IBOutlet weak var tvCommetNum: UILabel!
    
    @IBAction func support(sender: AnyObject) {
        ViewUtil.showToast(self, text: "点赞！还没实现", afterDelay: 2)
        ivSupport.highlighted = true
    }
    
    @IBAction func disSupport(sender: AnyObject) {
        ViewUtil.showToast(self, text: "点踩！测试，待实现", afterDelay: 2)
        ivShit.highlighted = true
    }
    
    @IBAction func reply(sender: AnyObject) {
        ViewUtil.showToast(self, text: "评论！测试，带实现", afterDelay: 2)
    }
    
}
