//
//  CCombStepThreeViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/7.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class CCombStepThreeViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var utfTotalMoney: UITextField!
    @IBOutlet weak var utfRestMoney: UILabel!
    @IBOutlet weak var segLevel: UISegmentedControl!
    
    @IBOutlet weak var viewCrashBg: UIView!
    @IBOutlet weak var labelCurrentMoney: UILabel!
    
    var cyTypes = Array<CurrencyType>()
    var ccomb:CComb!
    @IBOutlet weak var myTableView: UITableView!
    
    var CCOMB_totalMoney:CGFloat = 100000
    var CCOMB_lever = 100
    var CCOMB_remaining:CGFloat = 0
    var isCreate = true
    var combId = ""
    var situation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewCrashBg.setTranslatesAutoresizingMaskIntoConstraints(true) //清除 AutoLayout的影响
        
        var tMoney = NSString(format: "%.02lf", Float(CCOMB_totalMoney))
        utfTotalMoney.text = "\(tMoney)"
        switch CCOMB_lever {
        case 50:
            segLevel.selectedSegmentIndex = 1
        case 500:
            segLevel.selectedSegmentIndex = 2
        case 200:
            segLevel.selectedSegmentIndex = 3
        default:
            segLevel.selectedSegmentIndex = 0
        }
        
        getPrices()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        cyTypes = getChooseCurrencys()
        self.notifyDateChanged()
        myTableView.reloadData()
    }
    
    func getPrices() {
        var priceUrl = "http://112.74.195.144:8080/price/all"
        
        HttpUtil.get(priceUrl, success: {(response:AnyObject!) in
            //println(response)
            
            var dict = response["prices"] as NSDictionary
            var cacheDict = NSMutableDictionary()
            for cType in CURRENCT_ARRAY {
                cType.price = (dict[cType.key] as NSDictionary!)["ask"] as CGFloat
                cacheDict[cType.key] = cType
            }
            if self.isCreate {
                self.notifyDateChanged()
                self.myTableView.reloadData()
            } else {
                self.notifyDateChanged()
            }
        })
    }
    
    @IBAction func onSwitch(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            CCOMB_lever = 50
        case 2:
            CCOMB_lever = 500
        case 3:
            CCOMB_lever = 200
        default:
            CCOMB_lever = 100
        }
        notifyDateChanged()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CurrencyTypeCell", forIndexPath: indexPath) as UITableViewCell
        
        var ct = cyTypes[indexPath.row]
        
        var keyLabel = cell.viewWithTag(20) as UILabel
        var priceLabel = cell.viewWithTag(21) as UILabel
        var positionLabel = cell.viewWithTag(22) as UILabel
        var numUtf = cell.viewWithTag(23) as CurrencyTextField
        var oBtn = cell.viewWithTag(24) as CurrencyButton
        oBtn.indexPath = indexPath
        numUtf.indexPath = indexPath
        var rateStr = NSString(format: "%.02lf", Float(ct.rate) * 100.0)
        positionLabel.text = "\(rateStr) %"
        if !(ct.tradeNum < 0.001) {
            numUtf.text = "\(ct.tradeNum)"
        }
        var priceStr = NSString(format: "%.05lf", Float(ct.price))
        priceLabel.text = "\(priceStr)"
        keyLabel.text = ct.value
        
        if ct.operation == "SELL" {
            oBtn.backgroundColor = Colors.SellYellowColor
            oBtn.setTitle("空仓", forState: UIControlState.Normal)
        } else {
            oBtn.backgroundColor = Colors.WordMainBlueColor
            oBtn.setTitle("多仓", forState: UIControlState.Normal)
        }
        oBtn.addTarget(self, action: "sellOrBuy:", forControlEvents: UIControlEvents.TouchUpInside)
        numUtf.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cyTypes.count
    }
    
    func sellOrBuy(obtn:CurrencyButton) {
        var cType = cyTypes[obtn.indexPath.row]
        if cType.operation == "SELL" {
            cType.operation = "BUY"
            obtn.backgroundColor = Colors.WordMainBlueColor
            obtn.setTitle("多仓", forState: UIControlState.Normal)
        } else {
            cType.operation = "SELL"
            obtn.backgroundColor = Colors.SellYellowColor
            obtn.setTitle("空仓", forState: UIControlState.Normal)
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        var num = NSString(string: textField.text).floatValue
        
        textField.text = NSString(format: "%.02lf", num)
        
        if textField is CurrencyTextField {
            //修改的是手数
            var indexPath =  (textField as CurrencyTextField).indexPath
            if indexPath.row < cyTypes.count { //在调仓时，删除了某个品种，但是textFieldDidEndEditing还没调用，这时调用会出现数组越界错误，模拟机上会出现，手机上不知道会不会出现，统一判断下，防止这个错误
                var cType = cyTypes[indexPath.row]
                cType.setCurrentRate(CGFloat(num), totalMoney: CCOMB_totalMoney, lever: CCOMB_lever)
                
                var priceStr = NSString(format: "%.02lf", Float(cType.rate) * 100.0) //保留两位小数
                //(myTableView.cellForRowAtIndexPath(indexPath)!.viewWithTag(22) as UILabel).text = "\(cType.rate * 100) %"
                (myTableView.cellForRowAtIndexPath(indexPath)!.viewWithTag(22) as UILabel).text = "\(priceStr) %"
                notifyRowChanged()
            }
        } else {
            //修改的是总金额
            CCOMB_totalMoney = CGFloat(num)
            notifyDateChanged()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func notifyRowChanged() {
        var sumRate:CGFloat = 0
        for cType in cyTypes {
            sumRate += cType.rate
        }
        CCOMB_remaining = 1 - sumRate
        changeData()
    }
    
    func notifyDateChanged() {
        var sumRate:CGFloat = 0
        for cType in cyTypes {
            cType.setCurrentRate(cType.tradeNum, totalMoney: CCOMB_totalMoney, lever: CCOMB_lever)
            sumRate += cType.rate
        }
        myTableView.reloadData()
        CCOMB_remaining = 1 - sumRate
        changeData()
    }
    
    func changeData() {
        if CCOMB_remaining < 0.0001 {
            UIAlertView(title: "您的现金不够，请重新设置!", message: "", delegate: self, cancelButtonTitle: "确定").show()
        }
        self.viewCrashBg.frame = CGRectMake(0, 528, 320.0 * CCOMB_remaining, 40)
        var restRate = NSString(format: "%.02lf", Float(CCOMB_remaining) * Float(100))
        //self.labelCurrentMoney.text = "\(CCOMB_remaining * 100)"
        self.labelCurrentMoney.text = "\(restRate)"
        self.utfRestMoney.text = "$\(CCOMB_remaining * CGFloat(CCOMB_lever) * CCOMB_totalMoney)"
    }
    
    @IBAction func finishCreate(sender: UIBarButtonItem) {
        var array = Array<String>()
        for cType in cyTypes {
            //println(cType.toJsonString())
            array.append(cType.toJsonString())
        }
        println("\(array)", "")
        if isCreate { //新建组合
            var params = ["token":app.user.id, "username": app.user.getUsername(), "combination_currency_types":"\(array)", "combination_lever":CCOMB_lever, "combination_cash_remaining":CCOMB_remaining, "amount":CCOMB_totalMoney, "combination_name":ccomb.name, "combination_description":ccomb.des, "combination_types":ccomb.aType]
            
            HttpUtil.post(URLConstants.addCombinationUrl(), params: params, success: {(response:AnyObject!) in
                println(response)
                ViewUtil.showToast(self.view, text: "创建组合成功!", afterDelay: 2)
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "closeCreate", userInfo: nil, repeats: false)
            })
        } else { //调仓
            var params = ["token":app.user.id, "username": app.user.getUsername(), "combination_currency_types":"\(array)", "combination_lever":CCOMB_lever, "combination_cash_remaining":CCOMB_remaining, "amount":CCOMB_totalMoney, "combination_id":combId]
            
            HttpUtil.post(URLConstants.adjustCombinationUrl(), params: params, success: {(response:AnyObject!) in
                println(response)
                ViewUtil.showToast(self.view, text: "调仓成功!", afterDelay: 2)
                
                //TODO 创建组合成功
                NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "closeAdjust", userInfo: nil, repeats: false)
            })
        }
    }
    
    func closeCreate() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func closeAdjust() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func modifyTypes(sender: UIButton) {
        //self.navigationController?.popViewControllerAnimated(true)
        //adjust = true
        sender.becomeFirstResponder()
        var usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
        var stepTwoVc = usb.instantiateViewControllerWithIdentifier("AddCombStepSecordUI") as CCombStepTwoViewController
        stepTwoVc.ccomb = ccomb
        stepTwoVc.cyTypes = CURRENCT_ARRAY
        stepTwoVc.adjust = true
        self.navigationController?.pushViewController(stepTwoVc, animated: true)
    }
    
    func getChooseCurrencys() -> Array<CurrencyType> {
        var array = Array<CurrencyType>()
        for currencyType in CURRENCT_ARRAY {
            if currencyType.isSelected {
                array.append(currencyType)
            }
        }
        return array
    }

}

class CurrencyButton: UIButton {
    var indexPath:NSIndexPath!
    var btn:CurrencyButton!
    var str:CurrencyButton!
}

class CurrencyTextField: UITextField {
    var indexPath:NSIndexPath!
}
