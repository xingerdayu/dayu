//
//  GroupListViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class GroupListViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var myTableView: UITableView!
    
    private var groupList = NSMutableArray();
    
    func getGroupList() {
        var params = ["token":app.getToken()]
        HttpUtil.post(URLConstants.getJoinedGroupsUrl, params: params, success: {(data:AnyObject!) in
            println("group data = \(data)")
            if data["stat"] as String == "OK" {
                self.groupList.removeAllObjects()
                var array = data["groups"] as NSArray
                for item in array {
                    var group = Group()
                    group.parse(item as NSDictionary)
                    self.groupList.addObject(group)
                }
                self.myTableView.reloadData()
            }
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                println(error.localizedDescription)
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        
        getGroupList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var group = groupList[indexPath.row] as Group
        
        var cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as UITableViewCell
        
        var ivPhoto = cell.viewWithTag(11) as UIImageView
        var lbName = cell.viewWithTag(12) as UILabel
        var lbTime = cell.viewWithTag(13) as UILabel
        var lbUserNum = cell.viewWithTag(15) as UILabel
        
        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getImageUrl(group)), placeholderImage: UIImage(named: "user_default_photo.png"))
        
        lbName.text = group.name
        lbTime.text = group.timeString;
        lbUserNum.text = "\(group.num)人"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
