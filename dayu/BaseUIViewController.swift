//
//  BaseUIViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    var app = UIApplication.sharedApplication().delegate as AppDelegate

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        MobClick.beginLogPageView(self.title)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        MobClick.endLogPageView(self.title)
    }

}
