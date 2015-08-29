//
//  CombListViewController.swift
//  dayu
//
//  Created by 王毅东 on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit
class CombListViewController: BaseUIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var UlDataInCircle: UILabel!
    
    @IBOutlet weak var UlNameInCircle: UILabel!
    
    @IBOutlet weak var UlTime: UILabel!
    
    @IBOutlet weak var UlName: UILabel!
    
    @IBOutlet weak var UivArrow: UIImageView!
    
    @IBOutlet weak var UivSurpport: UIImageView!
    
    @IBOutlet weak var UlSurpportNum: UILabel!
    
    @IBOutlet weak var UivFollow: UIImageView!
    
    @IBOutlet weak var UlFollowNum: UILabel!
    
    @IBOutlet weak var UlBodonglv: UILabel!
    
    @IBOutlet weak var UlScore: UILabel!
    
    
    @IBAction func login(sender: AnyObject) {
        var params = ["tel": utfUsername.text, "password": utfPwd.text]
        
        HttpUtil.post(URLConstants.loginUrl, params: params, success: {(response:AnyObject!) in
            println(response)
            var stat = response["stat"] as String;
            
            if stat == "ERR_TEL_OR_PWD" {
                ViewUtil.showAlertView("登录失败", message:"用户名或密码错误!", view: self)
            } else if stat == "OK" {
                var user = User()
                user.parse(response["user"] as NSDictionary)
                self.app.user = user
                self.app.token = response["token"] as NSDictionary
            }
            }, failure:{(error:NSError!) in
                println(error.localizedDescription)
        })
        
    }
    
}