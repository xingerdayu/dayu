//
//  BaseUIViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAutoLayout(self.view)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //MobClick.beginLogPageView(self.title)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //MobClick.endLogPageView(self.title)
    }
    
    func myAutoLayout(mView:UIView) {
        if mView.subviews.count > 0 {
            for tView in mView.subviews {
                let oframe = tView.frame
                tView.frame = getScaleCGRect(oframe.origin.x, y: oframe.origin.y, width: oframe.width, height: oframe.height)
                myAutoLayout(tView)
            }
        }
    }

    func getScaleCGRect(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat) -> CGRect {
        return CGRectMake(x * app.autoSizeScaleX, y * app.autoSizeScaleY, width * app.autoSizeScaleX, height * app.autoSizeScaleY)
    }
}
