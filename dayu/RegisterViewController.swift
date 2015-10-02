//
//  RegisterViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/5.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class RegisterViewController: BaseUIViewController {

    @IBOutlet weak var utfNick: UITextField!
    @IBOutlet weak var utfAccount: UITextField!
    @IBOutlet weak var utfPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        utfPwd.resignFirstResponder()
//        utfAccount.resignFirstResponder()
//        utfNick.resignFirstResponder()
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        utfPwd.resignFirstResponder()
        utfAccount.resignFirstResponder()
        utfNick.resignFirstResponder()
    }
    
    @IBAction func register(sender: AnyObject) {
        if utfNick.text!.isEmpty {
            ViewUtil.showToast(self.view, text: "用户名不能为空!", afterDelay: 1)
            return
        }
        if utfAccount.text!.isEmpty {
            ViewUtil.showToast(self.view, text: "用户手机号码为空!", afterDelay: 1)
            return
        }
        if utfPwd.text!.isEmpty {
            ViewUtil.showToast(self.view, text: "用户密码为空!", afterDelay: 1)
            return
        }
        if utfPwd.text!.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) < 6 {
            ViewUtil.showToast(self.view, text: "亲!密码太短哦", afterDelay: 1)
            return
        }
        let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString.md5;
        let params = ["tel":utfAccount.text!, "username":utfNick.text!, "password":utfPwd.text!.md5, "code":"123456", "device_id": deviceId, "umeng_id":deviceId]
        
        HttpUtil.post(URLConstants.registerUrl, params: params, success: {(response:AnyObject!) in
            self.app.saveUser(response)
            
            //TODO做跳转
        })
    }

}
