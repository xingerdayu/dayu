//
//  ViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/27.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit
let kStoreAppId = 1041647380

class ViewController: BaseUIViewController, UIAlertViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBarHidden = true
        
        UpdateUtils.checkUpdate(self, isNew: {})
        
        let au = UserDao.get()
        if au == nil {
            let params = ["device_id": UIDevice.currentDevice().identifierForVendor!.UUIDString.md5]
            
            HttpUtil.post(URLConstants.guestUrl, params: params, success: {(response:AnyObject!) in
                print(response)
                self.app.saveUser(response)
                
                self.toMain()
            })
        } else {
            app.user = au!
            
            self.toMain()
        }
    }

    func toMain() {
        let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let mainVc = usb.instantiateViewControllerWithIdentifier("ucMainView") as UIViewController
        self.presentViewController(mainVc, animated: true, completion: {})
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 10000{
            if buttonIndex == 1 {
                let url = NSURL(string: String(format: "http://itunes.apple.com/us/app/id/%d?ls=1&mt=8", kStoreAppId))
                
                UIApplication.sharedApplication().openURL(url!)
            }
            
        }
    }
    
}

