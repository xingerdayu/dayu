//
//  OneCombListViewController.swift
//  dayu
//
//  Created by 王毅东 on 15/9/17.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import Foundation
class OneCombListViewController: BaseUIViewController ,UITableViewDataSource, UITableViewDelegate {
    private var combList = NSMutableArray();
    
    @IBOutlet weak var UtvCombs: UITableView!
    
    func getCombList() {
        combList.removeAllObjects()
        let params = ["token":app.user.id]
        HttpUtil.post(URLConstants.getCombinationsUrl, params: params, success: {(data:AnyObject!) in
            print("combs data = \(data)")
            if data["stat"] as! String == "OK" {
                self.combList.removeAllObjects()
                let array = data["combinations"] as! NSArray
                for item in array {
                    let comb = Comb()
                    comb.parse(item as! NSDictionary)
                    self.combList.addObject(comb)
                }
                self.UtvCombs.reloadData()
            }
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                print(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        getCombList();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        ulDataInCircle.text = StringUtil.formatFloat(comb.pro) + "%"
        ulTypeInCircle.text = "总收益"
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
                    //if data["stat"] as! String == "OK" {
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
            
        }
    }
    
    func follow(btn: CurrencyButton) {
        let indexPath = btn.indexPath.row
        let comb = combList[indexPath] as! Comb
        if app.isLogin() {
            let params = ["id":comb.id, "token_supporter":app.user.id, "token_host":comb.uid]
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
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return combList.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func addComb(sender: AnyObject) {
        let usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
        let vc = usb.instantiateViewControllerWithIdentifier("CreateCombStepOneUI") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
}