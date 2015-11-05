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
        //println("token = \(app.getToken())")
        let params = ["token":app.getToken()]
        HttpUtil.post(URLConstants.getJoinedGroupsUrl, params: params, success: {(data:AnyObject!) in
            //println("group data = \(data)")
            if data["stat"] as! String == "OK" {
                self.groupList.removeAllObjects()
                let array = data["groups"] as! NSArray
                for item in array {
                    let group = Group()
                    group.parse(item as! NSDictionary)
                    self.groupList.addObject(group)
                }
                self.myTableView.reloadData()
            }
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                print(error.localizedDescription)
        })
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
        print("Coming")
        
        self.title = "圈子"
        getGroupList()
        
        //myTableView.registerNib(UINib(nibName: "", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let group = groupList[indexPath.row] as! Group
        
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as UITableViewCell
        myAutoLayout(cell)
        
        let bgView = cell.viewWithTag(10) as UIView?
        
        bgView?.hidden = !group.on
        
        let ivPhoto = cell.viewWithTag(11) as! UIImageView
        let lbName = cell.viewWithTag(12) as! UILabel
        let lbTime = cell.viewWithTag(13) as! UILabel
        let lbUserNum = cell.viewWithTag(15) as! UILabel
        
        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getImageUrl(group)), placeholderImage: UIImage(named: "user_default_photo.png"))
        
        lbName.text = group.name
        lbTime.text = group.timeString;
        lbUserNum.text = "\(group.num)人"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90 * app.autoSizeScaleY
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let group = groupList[indexPath.row] as! Group
        let usb = UIStoryboard(name: "Group", bundle: NSBundle.mainBundle())
        let topicVc = usb.instantiateViewControllerWithIdentifier("TopicListViewController") as! TopicListViewController
        topicVc.group = group
        topicVc.title = group.name
        self.navigationController?.pushViewController(topicVc, animated: true)
    }

}
