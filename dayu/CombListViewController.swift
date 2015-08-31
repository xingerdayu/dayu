//
//  CombListViewController.swift
//  dayu
//
//  Created by 王毅东 on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit
class CombListViewController: BaseUIViewController ,UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var UtvCombs: UITableView!
    private var combList = NSMutableArray();
    
    func getCombList() {
        var params = ["token":app.getToken(), "type":"pro", "timetype":"S", "startnum":0]
        HttpUtil.post(URLConstants.getSortCombinationsUrl, params: params, success: {(data:AnyObject!) in
            println("combs data = \(data)")
            if data["stat"] as String == "OK" {
                self.combList.removeAllObjects()
                var array = data["combinations"] as NSArray
                for item in array {
                    var comb = Comb()
                    comb.parse(item as NSDictionary)
                    self.combList.addObject(comb)
                }
                self.UtvCombs.reloadData()
            }
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                println(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCombList();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var comb = combList[indexPath.row] as Comb
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CombCell", forIndexPath: indexPath) as UITableViewCell
        
        var uivCircle = cell.viewWithTag(10) as UIImageView
        var ulDataInCircle = cell.viewWithTag(11) as UILabel
        var ulTypeInCircle = cell.viewWithTag(12) as UILabel
        var ulTime = cell.viewWithTag(13) as UILabel
        var ulName = cell.viewWithTag(14) as UILabel
        var uivArrow = cell.viewWithTag(15) as UIImageView
        var uivSupport = cell.viewWithTag(16) as UIImageView
        var ulSupportNum = cell.viewWithTag(17) as UILabel
        var uivFollow = cell.viewWithTag(18) as UIImageView
        var ulFollowtNum = cell.viewWithTag(19) as UILabel
        var ulBodonglv = cell.viewWithTag(20) as UILabel
        var ulGrade = cell.viewWithTag(21) as UILabel
        
//        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getImageUrl(group)), placeholderImage: UIImage(named: "user_default_photo.png"))
        
        ulTime.text = StringUtil.formatTime(comb.createTime) + " \(comb.userName)创建"
        ulName.text = comb.name
        ulSupportNum.text = String(comb.supportNum)
        ulFollowtNum.text = String(comb.followNum)
        ulBodonglv.text = String(comb.gradego)
        ulGrade.text = String(comb.grade)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}