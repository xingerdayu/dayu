//
//  ModifyIntroViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/10.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class ModifyIntroViewController: BaseUIViewController, UITextViewDelegate {

    @IBOutlet weak var utfIntro: UITextView!
    @IBOutlet weak var wordLabel: UILabel!
    
    override func viewDidLoad() {
        utfIntro.layer.borderColor = Colors.MyLightGrayColor.CGColor
        utfIntro.layer.borderWidth = 1
        utfIntro.layer.masksToBounds = true
        
        utfIntro.text = app.user.intro
    }

    @IBAction func saveIntro(sender: UIButton) {
        let intro = utfIntro.text
        let params = ["token":app.getToken(), "intro":intro]
        
        HttpUtil.post(URLConstants.updateUserUrl, params: params, success: {(response:AnyObject!) in
            if response["stat"] as! String == "OK" {
                self.app.user.intro = intro
                UserDao.modifyIntro(intro, id: self.app.user.id)
                ViewUtil.showToast(self.view, text: "修改成功", afterDelay: 1)
                NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "cancel", userInfo: nil, repeats: false)
            }
            }
        )
    }
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        utfIntro.resignFirstResponder()
//    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        utfIntro.resignFirstResponder()
    }
    
    func cancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textViewDidChange(textView: UITextView) {
        changeLength()
    }
    
    func changeLength() {
        let length = (utfIntro.text as NSString).length
        wordLabel.text = "\(length)/100"
    }
}
