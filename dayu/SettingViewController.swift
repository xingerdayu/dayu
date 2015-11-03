//
//  SettingViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/9.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class SettingViewController: BaseUIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate {
    
    @IBOutlet weak var logoutBtn: UIButton!
    var settingItems = Array<UserCenterItem>()
    var versionName:Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
//        settingItems.append(UserCenterItem(name: "新版本检测", icon: "item_version_check.png"))
        settingItems.append(UserCenterItem(name: "意见反馈", icon: "item_suggest_post.png"))
        settingItems.append(UserCenterItem(name: "关于大鱼", icon: "item_help_center.png"))
        
        if !app.isLogin() {
            logoutBtn.hidden = true
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 10000{
            if buttonIndex == 1 {
                let url = NSURL(string: String(format: "http://itunes.apple.com/us/app/id/%s?ls=1&mt=8", kStoreAppId))
                UIApplication.sharedApplication().openURL(url!)
            }
            
        }
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        if indexPath.row == 0 {
            let vc = usb.instantiateViewControllerWithIdentifier("FeedBackViewUI") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = usb.instantiateViewControllerWithIdentifier("AboutDayuUI") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        else {
//            //TODO 版本检测
//            //ViewUtil.showToast(self.view, text: "当前已是最新版本!", afterDelay: 1)
//            UpdateUtils.checkUpdate(self, isNew: {
//                ViewUtil.showToast(self.view, text: "当前已是最新版本!", afterDelay: 1)
//            })
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingItemCell", forIndexPath: indexPath) as UITableViewCell
        
        let item = settingItems[indexPath.row]
        
        let icon = cell.viewWithTag(41) as! UIImageView
        let nameLabel = cell.viewWithTag(42) as! UILabel
        let versionLabel = cell.viewWithTag(43) as! UILabel
        
//        if indexPath.row == 0 {
//            versionLabel.hidden = false
//            let majorVersion: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
//            //println(majorVersion)
//            versionLabel.text = "V\(majorVersion!)"
//        } else {
            versionLabel.hidden = true
//        }
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