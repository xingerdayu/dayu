//
//  CombListViewController.swift
//  dayu
//
//  Created by 王毅东 on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit
class CombListViewController: BaseUIViewController ,UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate{
    

    @IBOutlet weak var UbTimeType: UIButton!
    @IBOutlet weak var UbType: UIButton!
    @IBOutlet weak var UtvCombs: UITableView!
    private var combList = NSMutableArray();
    private var type : String = "pro"
    private var timeType : String = "S"
    var refreshControl = UIRefreshControl()
    
    var typeStr = ["pro", "drawdown", "grade","hot"]
    var timeTypeStr = ["D", "W", "M","S"]
    var select = [type, timeType]
    var ubsTypeStr = ["排序 收益", "排序 波动", "排序 得分","排序 人气"]
    var ubsTimeTypeStr = ["日", "周", "月","总"]
    var typeFlag = [0,0]
    
    
    @IBAction func type(sender: AnyObject) {
        selectType()
    }
    
    
    @IBAction func timeType(sender: AnyObject) {
        selectTimeType()
    }
    
    
    func getCombList() {
        println(type + "--" + timeType)
        combList.removeAllObjects()
        var params = ["token":app.getToken(), "type":type, "timetype":timeType, "startnum":0]
        HttpUtil.post(URLConstants.getSortCombinationsUrl, params: params, success: {(data:AnyObject!) in
            self.refreshControl.endRefreshing()
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
                self.refreshControl.endRefreshing()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        refreshControl.addTarget(self, action: "getCombList", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "加载更多")
        refreshControl.frame.size = CGSizeMake(320, 20)
        UtvCombs.addSubview(refreshControl)
        getCombList();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectType() {
        var asType = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "收益", "波动", "得分","人气")
        asType.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        asType.tag = 0
        asType.showInView(self.view)
    }
    func selectTimeType() {
        var asTimeType = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "日", "周", "月","总")
        asTimeType.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        asTimeType.tag = 1
        asTimeType.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var ubsStrs = [ubsTypeStr,ubsTimeTypeStr]
        var selectStr = [typeStr,timeTypeStr]
        var ubs = [UbType,UbTimeType]
        var tag = actionSheet.tag
        println("tag == \(tag)")
        if buttonIndex == 0 {
            return
        } else {
            //select[tag] = selectStr[tag][buttonIndex - 1]
            if tag == 0 {
                type = selectStr[tag][buttonIndex - 1]
            } else {
                timeType = selectStr[tag][buttonIndex - 1]
            }
            ubs[tag].titleLabel?.text = ubsStrs[tag][buttonIndex - 1]
//            ubs[tag].setTitle(<#title: String?#>, forState: <#UIControlState#>)
            typeFlag[tag] = buttonIndex - 1
            getCombList()
        }
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
        var color = comb.getColor(comb.grade, g: comb.gradego)
        uivCircle.image = UIImage(named:color[0]);
        uivArrow.image = UIImage(named: color[1])
        ulTime.text = StringUtil.formatTime(comb.createTime) + " \(comb.userName)创建"
        ulName.text = comb.name
        ulSupportNum.text = String(comb.supportNum)
        ulFollowtNum.text = String(comb.followNum)
        ulBodonglv.text = String(StringUtil.formatFloat(comb.drawdown) + "%")
        ulBodonglv.textColor = StringUtil.colorWithHexString(color[2])
        ulGrade.text = String(comb.grade)
        ulDataInCircle.text = StringUtil.formatFloat(comb.pro) + "%"
        ulTypeInCircle.text = "\(ubsTimeTypeStr[typeFlag[1]])收益"
//        ulTime.lineBreakMode = UILineBreakModeCharacterWrap
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoDetail" {
            var vc = segue.destinationViewController as CombDetailViewController
            var indexPath = UtvCombs.indexPathForSelectedRow()
            if let index = indexPath {
                vc.comb = combList[index.row] as Comb
            }
        }
    }
    
}