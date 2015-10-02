//
//  LoginViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/28.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class LoginViewController: BaseUIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true
    }

//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        utfUsername.resignFirstResponder()
//        utfPwd.resignFirstResponder()
//    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        utfUsername.resignFirstResponder()
        utfPwd.resignFirstResponder()
    }
    
    @IBOutlet weak var utfUsername: UITextField!
    
    @IBOutlet weak var utfPwd: UITextField!

    @IBAction func login(sender: AnyObject) {
        print(utfPwd.text!.md5)
        let params = ["tel": utfUsername.text!, "password": utfPwd.text!.md5]
        
        HttpUtil.post(URLConstants.loginUrl, params: params, success: {(response:AnyObject!) in
            print(response)
            let stat = response["stat"] as! String;
            
            if stat == "ERR_TEL_OR_PWD" {
                ViewUtil.showAlertView("登录失败", message:"用户名或密码错误!", view: self)
            } else if stat == "OK" {
                self.app.saveUser(response)
                
                let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let mainVc = usb.instantiateViewControllerWithIdentifier("ucMainView") as UIViewController
                //self.navigationController?.pushViewController(mainVc, animated: true)
                self.presentViewController(mainVc, animated: true, completion: {})
            }
            }, failure:{(error:NSError!) in
                print(error.localizedDescription)
        })

    }

}
