//
//  ViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/27.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class ViewController: BaseUIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var au = UserDao.get()
        println(au)
        if au == nil {
            var params = ["device_id": UIDevice.currentDevice().identifierForVendor.UUIDString.md5]
            
            HttpUtil.post(URLConstants.guestUrl, params: params, success: {(response:AnyObject!) in
                println(response)
                self.app.saveUser(response)
                
                self.toMain()
            })
        } else {
            app.user = au!
            
            self.toMain()
        }
    }

    func toMain() {
        var usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var mainVc = usb.instantiateViewControllerWithIdentifier("ucMainView") as UIViewController
        self.presentViewController(mainVc, animated: true, completion: {})
    }
    
    
//    @IBAction func jump1(sender: AnyObject) {
//        var usb = UIStoryboard(name: "User", bundle: NSBundle.mainBundle())
//        var vc = usb.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func jump2(sender: AnyObject) {
//        var usb = UIStoryboard(name: "CombList", bundle: NSBundle.mainBundle())
//        var vc = usb.instantiateViewControllerWithIdentifier("CombListController") as UIViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func jump3(sender: AnyObject) {
//        var usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
//        var vc = usb.instantiateViewControllerWithIdentifier("CreateCombStepOneUI") as UIViewController
//        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
}

