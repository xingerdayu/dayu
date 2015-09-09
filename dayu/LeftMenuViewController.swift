//
//  LeftMenuViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/28.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class LeftMenuViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var items = Array<UserCenterItem>()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "个人中心"
        self.automaticallyAdjustsScrollViewInsets = false
        items.append(UserCenterItem(name: "个人中心", icon: "my_page.png"))
        items.append(UserCenterItem(name: "我的消息", icon: "my_topic.png"))
        items.append(UserCenterItem(name: "我的设置", icon: "my_setting.png"))
        //items.append(UserCenterItem(name: "个人中心", icon: "my_setting.png"))
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("UserCenterCell", forIndexPath: indexPath) as UITableViewCell
        var item = items[indexPath.row]
        
        var iconIv = cell.viewWithTag(31) as UIImageView
        var nameLabel = cell.viewWithTag(32) as UILabel
        
        iconIv.image = UIImage(named: item.itemIcon)
        nameLabel.text = item.itemName
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var identifier:String!
        switch indexPath.row {
        case 0:
            identifier = "SettingControllerUI"
        case 1:
            identifier = "MessageControllerUI"
        default:
            identifier = "SettingControllerUI"
        }
        var vc = usb.instantiateViewControllerWithIdentifier(identifier) as UIViewController
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