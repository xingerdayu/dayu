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
    var startNum = 0
    var moreData = true
    
    @IBAction func type(sender: AnyObject) {
        selectType()
    }
    
    
    @IBAction func timeType(sender: AnyObject) {
        selectTimeType()
    }
    
    
    func getCombList() {
        let params = ["token":app.user.id, "type":type, "timetype":timeType, "startnum":startNum]
        HttpUtil.post(URLConstants.getSortCombinationsUrl, params: params, success: {(data:AnyObject!) in
            self.refreshControl.endRefreshing()
            print("combs data = \(data)")
            //if data["stat"] as String == "OK" {
                let array = data["combinations"] as! NSArray
                if array.count > 0 && self.startNum == 0 {
                    self.moreData = true
                    self.combList.removeAllObjects()
                }
                if array.count == 0 {
                    ViewUtil.showToast(self.view, text: "没有更多了", afterDelay: 1)
                    self.moreData = false
                }
                for item in array {
                    let comb = Comb()
                    comb.parse(item as! NSDictionary)
                    self.combList.addObject(comb)
                }
                self.UtvCombs.reloadData()
            //}
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                print(error.localizedDescription)
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
        let asType = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "收益", "波动", "得分","人气")
        asType.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        asType.tag = 0
        asType.showInView(self.view)
    }
    func selectTimeType() {
        let asTimeType = UIActionSheet(title: "请选择", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "日", "周", "月","总")
        asTimeType.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        asTimeType.tag = 1
        asTimeType.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var ubsStrs = [ubsTypeStr,ubsTimeTypeStr]
        var selectStr = [typeStr,timeTypeStr]
        var ubs = [UbType,UbTimeType]
        let tag = actionSheet.tag
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
        let comb = combList[indexPath.row] as! Comb
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CombCell", forIndexPath: indexPath) as UITableViewCell
        
        let uivCircle = cell.viewWithTag(10) as! UIImageView
        let ulDataInCircle = cell.viewWithTag(11) as! UILabel
        let ulTypeInCircle = cell.viewWithTag(12) as! UILabel
        let ulTime = cell.viewWithTag(13) as! UILabel
        let ulName = cell.viewWithTag(14) as! UILabel
        let uivArrow = cell.viewWithTag(15) as! UIImageView




        let ulBodonglv = cell.viewWithTag(20) as! UILabel
        let ulGrade = cell.viewWithTag(21) as! UILabel
        let ubSupport = cell.viewWithTag(22) as! CurrencyButton
        let ubSupportStr = cell.viewWithTag(23) as! CurrencyButton
        let ubFollow = cell.viewWithTag(24) as! CurrencyButton
        let ubFollowStr = cell.viewWithTag(25) as! CurrencyButton
        
//        ivPhoto.sd_setImageWithURL(NSURL(string: URLConstants.getImageUrl(group)), placeholderImage: UIImage(named: "user_default_photo.png"))
        var color = comb.getColor(comb.grade, g: comb.gradego)
        uivCircle.image = UIImage(named:color[0]);
        uivArrow.image = UIImage(named: color[1])
        ulTime.text = (StringUtil.formatTime(comb.createTime) as NSString).substringToIndex(10) + " \(comb.userName)创建"
        ulName.text = comb.name
        ubSupportStr.setTitle(comb.supportNum.description, forState: UIControlState.Normal)
        ubFollowStr.setTitle(comb.followNum.description, forState: UIControlState.Normal)
        if comb.yesSupport == 1 {
            ubSupport.setImage(UIImage(named:"note_good_selected2.png"), forState: UIControlState.Normal)
        } else {
            ubSupport.setImage(UIImage(named:"note_good_normal.png"), forState: UIControlState.Normal)
        }
        if comb.yesFollow == 1 {
            ubFollow.setImage(UIImage(named:"ic_love_blue_selected.png"), forState: UIControlState.Normal)
        } else {
            ubFollow.setImage(UIImage(named:"ic_love_blue.png"), forState: UIControlState.Normal)
        }
        ulBodonglv.text = String(StringUtil.formatFloat(comb.drawdown) + "%")
        ulBodonglv.textColor = StringUtil.colorWithHexString(color[2])
        ulGrade.text = String(comb.grade)
        ulDataInCircle.text = StringUtil.formatFloat(comb.pro * 100) + "%"
        ulTypeInCircle.text = "\(ubsTimeTypeStr[typeFlag[1]])收益"
//        ulTime.lineBreakMode = UILineBreakModeCharacterWrap
        ubSupport.indexPath = indexPath
        ubSupport.btn = ubSupport
        ubSupport.str = ubSupportStr
        ubSupport.addTarget(self, action: "support:", forControlEvents: UIControlEvents.TouchUpInside)
        ubSupportStr.indexPath = indexPath
        ubSupportStr.btn = ubSupport
        ubSupportStr.str = ubSupportStr
        ubSupportStr.addTarget(self, action: "support:", forControlEvents: UIControlEvents.TouchUpInside)
        
        ubFollow.indexPath = indexPath
        ubFollow.btn = ubFollow
        ubFollow.str = ubFollowStr
        ubFollow.addTarget(self, action: "follow:", forControlEvents: UIControlEvents.TouchUpInside)
        ubFollowStr.indexPath = indexPath
        ubFollowStr.btn = ubFollow
        ubFollowStr.str = ubFollowStr
        ubFollowStr.addTarget(self, action: "follow:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func support(btn: CurrencyButton) {
        let indexPath = btn.indexPath.row
        let comb = combList[indexPath] as! Comb
        if app.isLogin() {
            if comb.yesSupport == 0 {
                let params = ["id":comb.id, "token_supporter":app.user.id, "token_host":comb.uid]
                HttpUtil.post(URLConstants.getSupportCombinationUrl, params: params, success: {(data:AnyObject!) in
                    print("combs data = \(data)")
                    //if data["stat"] as String == "OK" {
                        btn.btn.setImage(UIImage(named:"note_good_selected2.png"), forState: UIControlState.Normal)
                        comb.yesSupport = 1
                        comb.supportNum = comb.supportNum + 1
                        btn.str.setTitle(comb.supportNum.description, forState: UIControlState.Normal)
                    //}
                    }, failure:{(error:NSError!) in
                        //TODO 处理异常
                        print(error.localizedDescription)
                })
            } else {
                ViewUtil.showToast(UtvCombs, text: "您已经点过赞了", afterDelay: 1)
            }
        } else {
            ViewUtil.showToast(UtvCombs, text: "请先登录", afterDelay: 1)
        }
    }
    
    func follow(btn: CurrencyButton) {
        let indexPath = btn.indexPath.row
        let comb = combList[indexPath] as! Comb
        if app.isLogin() {
            let params = ["id":comb.id, "token_follower":app.user.id, "token_host":comb.uid]
            print("\(comb.id) -- \(app.user.id) -- \(comb.uid)")
            if comb.yesFollow == 0 {
                HttpUtil.post(URLConstants.getFollowCombinationUrl, params: params, success: {(data:AnyObject!) in
                    print("combs data = \(data)")
                    //if data["stat"] as String == "OK" {
                        btn.btn.setImage(UIImage(named:"ic_love_blue_selected.png"), forState: UIControlState.Normal)
                        comb.yesFollow = 1
                        comb.followNum = comb.followNum + 1
                        btn.str.setTitle(comb.followNum.description, forState: UIControlState.Normal)
                        ViewUtil.showToast(self.UtvCombs, text: "关注成功，该组合的调仓都会通知您", afterDelay: 1.5)
                    //}
                    }, failure:{(error:NSError!) in
                        //TODO 处理异常
                        print(error.localizedDescription)
                })
            } else {
                HttpUtil.post(URLConstants.getCancelFollowCombinationUrl, params: params, success: {(data:AnyObject!) in
                    print("combs data = \(data)")
                    //if data["stat"] as String == "OK" {
                        btn.btn.setImage(UIImage(named:"ic_love_blue.png"), forState: UIControlState.Normal)
                        comb.yesFollow = 0
                        comb.followNum = comb.followNum - 1
                        btn.str.setTitle(comb.followNum.description, forState: UIControlState.Normal)
                        ViewUtil.showToast(self.UtvCombs, text: "取消关注成功", afterDelay: 1)
                    //}
                    }, failure:{(error:NSError!) in
                        //TODO 处理异常
                        print(error.localizedDescription)
                })
            }
        } else {
            ViewUtil.showToast(UtvCombs, text: "请先登录", afterDelay: 1)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            //滑到底部加载更多
            if moreData {
                startNum = startNum + 1
                getCombList()
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GoDetail" {
            let vc = segue.destinationViewController as! CombDetailViewController
            let indexPath = UtvCombs.indexPathForSelectedRow
            if let index = indexPath {
                vc.comb = combList[index.row] as! Comb
            }
        }
    }
    
    @IBAction func addComb(sender: AnyObject) {
        let usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
        let vc = usb.instantiateViewControllerWithIdentifier("CreateCombStepOneUI") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }    
}