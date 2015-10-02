//
//  LeftMenuViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/28.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseChooseImageViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = Array<UserCenterItem>()
    @IBOutlet weak var photoImageView: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.automaticallyAdjustsScrollViewInsets = false
        items.append(UserCenterItem(name: "个人中心", icon: "my_page.png"))
        items.append(UserCenterItem(name: "我的消息", icon: "my_topic.png"))
        items.append(UserCenterItem(name: "我的设置", icon: "my_setting.png"))
        //items.append(UserCenterItem(name: "个人中心", icon: "my_setting.png"))
        
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = 27
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlStr = URLConstants.getUserPhotoUrl(app.user.id)
        
        photoImageView.sd_setImageWithURL(NSURL(string: urlStr), forState:UIControlState.Normal)
        
        if app.isLogin() {
            loginBtn.setTitle(app.user.getUsername(), forState: UIControlState.Normal)
        } else {
            loginBtn.setTitle("注册/登录", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func uploadPhoto(sender: UIButton) {
        if app.isLogin() {
            super.chooseUploadType()
        } else {
            toLogin()
        }
    }

    @IBAction func login(sender: UIButton) {
        if app.isLogin() {
            let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = usb.instantiateViewControllerWithIdentifier("ModifyInfoViewUI") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            toLogin()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCenterCell", forIndexPath: indexPath) as UITableViewCell
        let item = items[indexPath.row]
        
        let iconIv = cell.viewWithTag(31) as! UIImageView
        let nameLabel = cell.viewWithTag(32) as! UILabel
        
        iconIv.image = UIImage(named: item.itemIcon)
        nameLabel.text = item.itemName
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var identifier:String!
        switch indexPath.row {
        case 0:
            identifier = "ModifyInfoViewUI"
        case 1:
            identifier = "MessageControllerUI"
        default:
            identifier = "SettingControllerUI"
        }
        let vc = usb.instantiateViewControllerWithIdentifier(identifier) as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func onUploadSuccess(chooseImage: UIImage?) {
        self.photoImageView.setImage(chooseImage, forState: UIControlState.Normal)
    }
    
    func toLogin() {
        let usb = UIStoryboard(name: "User", bundle: NSBundle.mainBundle())
        let vc = usb.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

class UserCenterItem {
    var itemName : String!
    var itemIcon : String!
    
    init(name:String, icon:String) {
        self.itemName = name
        self.itemIcon = icon
    }
}