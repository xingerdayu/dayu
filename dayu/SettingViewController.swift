//
//  SettingViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/9.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class SettingViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logoutBtn: UIButton!
    var settingItems = Array<UserCenterItem>()
    var versionName:Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        settingItems.append(UserCenterItem(name: "新版本检测", icon: "item_version_check.png"))
        settingItems.append(UserCenterItem(name: "意见反馈", icon: "item_suggest_post.png"))
        settingItems.append(UserCenterItem(name: "关于大鱼", icon: "item_help_center.png"))
        
        if !app.isLogin() {
            logoutBtn.hidden = true
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if indexPath.row == 1 {
            var vc = usb.instantiateViewControllerWithIdentifier("FeedBackViewUI") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            var vc = usb.instantiateViewControllerWithIdentifier("AboutDayuUI") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            //TODO 版本检测
            ViewUtil.showToast(self.view, text: "当前已是最新版本!", afterDelay: 1)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SettingItemCell", forIndexPath: indexPath) as UITableViewCell
        
        var item = settingItems[indexPath.row]
        
        var icon = cell.viewWithTag(41) as UIImageView
        var nameLabel = cell.viewWithTag(42) as UILabel
        var versionLabel = cell.viewWithTag(43) as UILabel
        
        if indexPath.row == 0 {
            versionLabel.hidden = false
        } else {
            versionLabel.hidden = true
        }
        icon.image = UIImage(named: item.itemIcon)
        nameLabel.text = item.itemName
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }

    @IBAction func logout(sender: UIButton) {
        UserDao.delete()
        app.user = UserDao.get()!
        self.navigationController?.popViewControllerAnimated(true)
    }
}