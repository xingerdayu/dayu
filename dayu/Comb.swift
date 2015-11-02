//
//  Comb.swift
//  dayu
//
//  Created by 王毅东 on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

class Comb: NSObject {
    
    var createTime:Int64 = 0
    var drawdown:Float = 0.0
    var followNum = 0
    var grade = 0
    var gradego = 0
    var id = ""
    var name = ""
    
    var pro:Float = 0.0
    var situation:Int = 0
    var supportNum:Int  = 0
    var uid = ""
    var userName = ""
    var yesFollow = 0
    var yesSupport = 0
    
    var types = 0
    var descriptionStr = ""
    var now_amount : Float = 0.0
    var cash_remaining : Float = 0.0
    var amount : Float = 0.0
    var lever = 0
    var modify_time:Int64 = 0
    var changeTimes = 0
    var recentEarning : Float = 0.0
    var recentpro : Float = 0.0
    var frequency_rate : Float = 0.0
    
    var grades = Array<Score>()
    var currencys = Array<Currency>()
    
    var contentLabelWidth:CGFloat = 280
    var MAXFLOAT = 26;
    
    func parse(dict:NSDictionary) {
        let t: AnyObject? = dict["id"]
        id = "\(t!)"
        createTime = (dict["create_time"] as! NSString).longLongValue
        grade = dict["grade"] as! Int
        drawdown = dict["drawdown"] as! Float
        name = dict["name"] as! String
        let f = dict["follownum"] as? Int
        if f != nil { followNum = f!}
        gradego = dict["gradego"] as! Int
        pro = dict["pro"] as! Float
        situation = dict["situation"] as! Int
        let s = dict["supportnum"] as? Int
        if s != nil { supportNum = s! }
        uid = dict["uid"] as! String
        let n = dict["username"] as? String
        if n != nil {userName = n!}
        yesFollow = dict["yesfollow"] as! Int
        yesSupport = dict["yessupport"] as! Int
    }
    
    func parseDetail(dict:NSDictionary) {
        types = dict["analysis_types"] as! Int
        descriptionStr = dict["description"] as! String
        now_amount = dict["now_amount"] as! Float
        cash_remaining = dict["cash_remaining"] as! Float
        amount = dict["amount"] as! Float
        lever = dict["lever"] as! Int
        modify_time = (dict["modify_time"] as! NSString).longLongValue
        changeTimes = dict["changetimes"] as! Int
        //recentEarning = dict["recentearning"] as Float
        //recentpro = dict["recentpro"] as Float
        frequency_rate = dict["frequency_rate"] as! Float
        var gradeStr = ["D", "W", "M", "S"]
        let json_score = dict["score"] as! NSDictionary
        for i in 0...3 {
            let s = Score()
            let json2 = json_score[gradeStr[i]] as! NSDictionary
            s.grade = json2["grade"] as! Int
            s.gradego = json2["gradego"] as! Int
            s.drawdown_mark_drawdown = json2["drawdown"] as! Double
            s.drawdown_mark_mark = json2["drawdown_mark"] as! Int
            s.pro_mark_pro = json2["pro"] as! Double
            s.pro_mark_mark = json2["pro_mark"] as! Int
            self.grades.append(s)
        }
        self.currencys.removeAll()
        let json_currency_types = dict["currency_types"] as! NSArray
        for i in 0..<json_currency_types.count {
            let c = Currency()
            let json3 = json_currency_types[i] as! NSDictionary
            c.value = json3["value"] as! String
            c.buyRate = json3["buyRate"] as! Float
            c.operation = json3["operation"] as! String
            c.key = json3["key"] as! String
            //c.lots = json3["lots"] as! Float
            var lots = json3["lots"] as? Float
            if lots == nil {
                lots = (json3["lots"] as? NSString)?.floatValue
            } else {
                c.lots = lots!
            }
            c.earning = json3["earning"] as! Float
            c.selected = true
            self.currencys.append(c)
        }
        let cash = Currency()
        cash.value = "可用保证金"
        cash.buyRate = self.cash_remaining
        cash.key = "cash_remaining"
        cash.operation = ""
        self.currencys.append(cash)
    }
    
    class Score {
        var grade : Int = 0
        var gradego : Int = 0
        var drawdown_mark_drawdown : Double = 0
        var drawdown_mark_mark : Int = 0
        var pro_mark_pro : Double = 0
        var pro_mark_mark : Int = 0
    }
    
    class Currency {
        var key = ""
        var value = ""
        var buyRate : Float = 0.0
        var operation = ""
        var lots : Float = 0.0
        var selected : Bool = false
        var earning : Float = 0.0
    }
    
//    func getNameWidth() -> CGFloat {
//        var size = name.textSizeWithFont(UIFont.systemFontOfSize(FONT_SIZE), constrainedToSize: CGSizeMake(20000, 22))
////        CGSize titleSize = [aString sizeWithFont,font constrainedToSize:CGSizeMake(MAXFLOAT, 30)]
////        if imageNum > 0 {
////            imageGroupHeight = defaultImageGroupHeight
////        }
////        var text: NSString = NSString(CString: name.cStringUsingEncoding(NSUTF8StringEncoding)!,
////            encoding: NSUTF8StringEncoding)
////        text.sizeWithAttributes(attrs: [NSObject : AnyObject]!)
//        
//        return contentLabelOffsetY + size.height + imageGroupHeight + marginTop * 3 + 30
//    }
    
    func getColor(s: Int, g: Int) -> [String] {
        var colors = [String](count: 4, repeatedValue: "")
        if s < 20 {
            colors[0] = "comb_circle_1"
            colors[1] = g > 0 ? "comb_up_1" : "comb_down_1"
            colors[2] = "#999999"
        } else if s < 40 {
            colors[0] = "comb_circle_2"
            colors[1] = g > 0 ? "comb_up_2" : "comb_down_2"
            colors[2] = "#397ada"
        } else if s < 60 {
            colors[0] = "comb_circle_3"
            colors[1] = g > 0 ? "comb_up_3" : "comb_down_3"
            colors[2] = "#44b74f"
        } else if s < 80 {
            colors[0] = "comb_circle_4"
            colors[1] = g > 0 ? "comb_up_4" : "comb_down_4"
            colors[2] = "#fda126"
        } else {
            colors[0] = "comb_circle_5"
            colors[1] = g > 0 ? "comb_up_5" : "comb_down_5"
            colors[2] = "#ef5a3a"
        }
        return colors
    }
    
    func toCyTypes(comb: Comb) -> Array<CurrencyType> {
        let all = CurrencyType.createCurrencys()
        let cacheMap = NSMutableDictionary();
        for ct in all {
            cacheMap[ct.key] = ct
        }
        var cs = Array<CurrencyType>()
        for c in comb.currencys {
            if c.key != "cash_remaining" {
                let ct = cacheMap[c.key] as! CurrencyType
                //ct.key = c.key
                //ct.value = c.value
                ct.isSelected = c.selected
                ct.operation = c.operation
                ct.tradeNum = CGFloat(c.lots)
                cs.append(ct)
            }
            
        }
        return cs
    }
}