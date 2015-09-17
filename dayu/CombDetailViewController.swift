//
//  CombDetailViewController.swift
//  dayu
//
//  Created by 王毅东 on 15/9/7.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit
class CombDetailViewController: BaseUIViewController {
    var comb : Comb!
    
    @IBOutlet var uvMain: UIView!
    @IBOutlet weak var usvMain: UIScrollView!
    @IBOutlet weak var uIv: UIImageView!
    @IBOutlet weak var ulTime: UILabel!
    @IBOutlet weak var ulType1: UILabel!
    @IBOutlet weak var ulType2: UILabel!
    @IBOutlet weak var ulDescription: UILabel!
    @IBOutlet weak var ulRate: UILabel!
    @IBOutlet weak var ulUserName: UILabel!
    @IBOutlet weak var ulFollow: UILabel!
    
    
    @IBOutlet weak var ulScore: UILabel!
    @IBOutlet weak var ulPro: UILabel!
    @IBOutlet weak var ulFluctuate: UILabel!
    @IBOutlet weak var uivPro: UIImageView!
    @IBOutlet weak var uivFluctuate: UIImageView!
    @IBOutlet weak var ulProPercent: UILabel!
    @IBOutlet weak var ulFluactuatePercent: UILabel!
    @IBOutlet weak var ubChange: UIButton!
    @IBOutlet weak var uivProStar: UIImageView!
    @IBOutlet weak var uivRiskStar: UIImageView!
    
    
    
    @IBOutlet weak var ubReposition: UIButton!
    var fsLineView:FsLineView!
    //grade info 区域的年月日全， 0、1、2、3
    var flag = 3
    var flagStr = ["年", "月", "日", "总 "]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usvMain.contentSize.height = 800
        self.automaticallyAdjustsScrollViewInsets = false
        if app.user.id.description != comb.uid {
            if comb.yesSupport == 0 {
                ubReposition.setTitle("点赞", forState: UIControlState.Normal)
            } else {
                ubReposition.setTitle("已赞", forState: UIControlState.Normal)
            }
        }
        self.title = comb.name
        getCombList()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func getCombList() {
        println("id == \(comb.id)")
        var c = comb!
        println("idStr == \(c.id)")
        var params = ["id":c.id]
        HttpUtil.post(URLConstants.getCombinationDetialUrl, params: params, success: {(data:AnyObject!) in
            //println("combs data = \(data)")
            if data["stat"] as String == "OK" {
                var item = data["combinations"] as NSObject
                self.comb.parseDetail(item as NSDictionary)
                self.initView()
            }
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                println(error.localizedDescription)
        })
    }
    
    func initView() {
        uIv.sd_setImageWithURL(NSURL(string: URLConstants.getUserPhotoUrl(comb.uid.toInt()!)), placeholderImage:UIImage(named: "user_default_photo.png"))
        println(" URLConstants.getUserPhotoUrl(comb.uid.toInt()!) == \(URLConstants.getUserPhotoUrl(comb.uid.toInt()!))")
        uIv.layer.cornerRadius = 25
        uIv.clipsToBounds = true
        ulTime.text = "创建于" + StringUtil.formatTime(comb.createTime).substringToIndex(10) + " 修改于" + StringUtil.formatTime(comb.modify_time).substringToIndex(10)
        ulUserName.text = comb.userName
        ulDescription.text = comb.descriptionStr
        ulRate.text = "共调仓" + "\(comb.changeTimes)" + "次 均" + "\(StringUtil.formatFloat(comb.frequency_rate))" + "日/次"
        ulFollow.text = "\(comb.followNum)人关注"
        var typeArry = Array<String>()
        if comb.types & 1 > 0 {
            typeArry.append("事件分析")
        }
        if comb.types & 2 > 0 {
            typeArry.append("量化模型")
        }
        if comb.types & 4 > 0 {
            typeArry.append("技术分析")
        }
        if comb.types & 8 > 0 {
            typeArry.append("基本面分析")
        }
        if typeArry.count == 0 {
            typeArry.append("尚未设置组合类型")
        }
        var str1 = ""
        var str2 = ""
        for var i = 0; i < typeArry.count; i++ {
            if i < 2 {
                str1 = str1 + typeArry[i]
            }
            if i > 1 {
                str2 = str2 + typeArry[i]
            }
            if i == 0 && typeArry.count > 1 {
                str1 = str1 + " | "
            }
            if i == 2 && typeArry.count > 3 {
                str2 = str2 + " | "
            }
        }
        ulType1.text = str1
        ulType2.text = str2
        
        var pie = NSBundle.mainBundle().loadNibNamed("PieView", owner: self, options: nil)[0] as PieView
        pie.createMagicPie(comb)
        pie.frame = CGRectMake(0, 261 , 340, pie.utvUnderPie.frame.height + 275 )
        self.usvMain.addSubview(pie)
        
        fsLineView = NSBundle.mainBundle().loadNibNamed("FsLineView", owner: self, options: nil)[0] as FsLineView
        fsLineView.frame = CGRectMake(0, 210 + pie.frame.height, 340, 300)
        println("pie.frame.height == \(pie.frame.height)")
        usvMain.addSubview(fsLineView)
        fsLineView.getWave(comb, waveStyle: "S")
        
        var amount = NSBundle.mainBundle().loadNibNamed("AmountView", owner: self, options: nil)[0] as UIView
        var amount1 = amount.viewWithTag(1) as UILabel
        var amount2 = amount.viewWithTag(2) as UILabel
        amount1.text = "$\(StringUtil.formatFloat(comb.amount))"
        amount2.text = "$\(StringUtil.formatFloat(comb.now_amount))"
        amount.frame = CGRectMake(0, 120 + pie.frame.height + fsLineView.frame.height, 340, 45)
        self.usvMain.addSubview(amount)
        changeTime()
    }
    
    @IBAction func change(sender: AnyObject) {
        flag = (flag + 1) % 4
        changeTime()
    }
    
    func changeTime() {
        var score = comb.grades[flag]
        var proPic = getTrapezoidByScore(score.pro_mark_pro, type: 0)
        ulScore.text = "\(score.grade)"
        uivPro.image = UIImage(named: proPic)
        uivFluctuate.image = UIImage(named: getTrapezoidByScore(score.drawdown_mark_drawdown, type: 1))
        ulPro.text = "收益/\(flagStr[flag])"
        ulFluctuate.text = "波动/\(flagStr[flag])"
        ulProPercent.text = StringUtil.formatFloat(Float(score.pro_mark_pro)) + "%"
        ulFluactuatePercent.text = StringUtil.formatFloat(Float(score.drawdown_mark_drawdown)) + "%"
        uivProStar.image = UIImage(named: getStarByScore(score.pro_mark_mark))
        uivRiskStar.image = UIImage(named: getStarByScore(score.drawdown_mark_mark))
        var color = comb.getColor(score.grade , g: score.gradego)
//        uvMain.backgroundColor = StringUtil.colorWithHexString(color[2])
        usvMain.backgroundColor = StringUtil.colorWithHexString(color[2])
    }
    
    func getStarByScore(score: Int) -> String{
        if score < 10 {
            return "star5_0.png"
        } else if score < 30 {
            return "star5_1.png"
        } else if score < 50 {
            return "star5_2.png"
        } else if score < 70 {
            return "star5_3.png"
        } else if score < 90 {
            return "star5_4.png"
        } else {
            return "star5_5.png"
        }
    }
    
    func getTrapezoidByScore(score: Double, type: Int) -> String{
        var level1 : Double = 0
        var level2 : Double = 0
        var level3 : Double = 0
        if type == 0 {
            switch (flag) {
            case 0:
                level1 = 0.01
                level2 = 0.03
                level3 = 0.05
            case 1:
                level1 = 0.05
                level2 = 0.10
                level3 = 0.20
            case 2:
                level1 = 0.05
                level2 = 0.15
                level3 = 0.25
            case 3:
                level1 = 0.25
                level2 = 0.50
                level3 = 0.75
            default:
                level1 = 0
                level2 = 0
                level3 = 0
            }
        } else {
            level1 = 0.05
            level2 = 0.20
            level3 = 0.35
        }
        if score < level1 {
            return "fluctuation1.png"
        } else if score < level2 {
            return "fluctuation2.png"
        } else if score < level3 {
            return "fluctuation3.png"
        } else {
            return "fluctuation4.png"
        }
    }

    @IBAction func goReposition(sender: AnyObject) {
        if app.user.id.description == comb.uid {
            var usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
            var groupVc = usb.instantiateViewControllerWithIdentifier("CCombStepThreeViewUI") as CCombStepThreeViewController
            groupVc.CCOMB_totalMoney = CGFloat(comb.now_amount)
            groupVc.CCOMB_lever = comb.lever
            groupVc.isCreate = false
            groupVc.combId = comb.id
            groupVc.situation = comb.situation
            groupVc.cyTypes = comb.toCyTypes(comb)
            self.navigationController?.pushViewController(groupVc, animated: true)
        } else {
            support()
        }
    }
    
    func support() {
        if app.isLogin() {
            if comb.yesSupport == 0 {
                var params = ["id":comb.id, "token_supporter":app.user.id, "token_host":comb.uid]
                HttpUtil.post(URLConstants.getSupportCombinationUrl, params: params, success: {(data:AnyObject!) in
                    println("combs data = \(data)")
                    if data["stat"] as String == "OK" {
                        self.ubReposition.setTitle("已赞", forState: UIControlState.Normal)
                        self.comb.yesSupport = 1
                        self.comb.supportNum = self.comb.supportNum + 1
                    }
                    }, failure:{(error:NSError!) in
                        //TODO 处理异常
                        println(error.localizedDescription)
                })
            } else {
                ViewUtil.showToast(self.uvMain, text: "您已经点过赞了", afterDelay: 1)
            }
        } else {
            
        }
    }
}
