//
//  CurrencyType.swift
//  dayu
//
//  Created by Xinger on 15/9/7.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

//enum Operation {
//    case BUY, SELL
//}
let CURRENCY_TYPE_COUNT = 19

let CurrencyKeys = ["EUR/USD", "XAU/USD", /**"XAG/USD",**/ "GBP/USD",
    "EUR/JPY", "USD/JPY", "GBP/JPY", "AUD/JPY", "EUR/CAD", "EUR/GBP",
    "AUD/USD", "EUR/AUD", "USD/CAD", "USD/CHF", "EUR/CHF", "GBP/CHF",
    "AUD/NZD", "EUR/NZD", "NZD/USD", "NZD/JPY"]

let CurrencyValues = ["欧元/美元", "黄金/美元", /**"白银/美元",**/ "英镑/美元",
    "欧元/日元", "美元/日元", "英镑/日元", "澳元/日元", "欧元/加元", "欧元/英镑",
    "澳元/美元", "欧元/澳元", "美元/加元", "美元/瑞郎", "欧元/瑞郎", "英镑/瑞郎",
    "澳元/纽元", "欧元/纽元", "纽元/美元", "纽元/日元"]

var CURRENCT_ARRAY = Array<CurrencyType>()

class CurrencyType : NSObject {
    
    var key:String!
    var value:String!
    var isSelected = false
    var operation = "SELL"
    var tradeNum:CGFloat = 0
    var price:CGFloat = 0
    var rate:CGFloat = 0 //交易所占金额比例
    
    class func createCurrencys() -> Array<CurrencyType> {
        if (CURRENCT_ARRAY.count == 0) {
            for var i = 0; i < CURRENCY_TYPE_COUNT; i++ {
                var currencyType = CurrencyType()
                currencyType.key = CurrencyKeys[i]
                currencyType.value = CurrencyValues[i]
                CURRENCT_ARRAY.append(currencyType)
            }
        }
        return CURRENCT_ARRAY
    }
    
    //仓位计算方法
    func setCurrentRate(num:CGFloat, totalMoney:CGFloat, lever: Int) {
        tradeNum = num
        if key.componentsSeparatedByString("USD").count > 1 {
            if key.componentsSeparatedByString("XAU").count > 1 {
                //黄金
                rate = price * CGFloat(100) * num / (totalMoney * CGFloat(lever))
            } else if key.componentsSeparatedByString("XAG").count > 1 {
                //白银
                rate = price * CGFloat(5000) * num / (totalMoney * CGFloat(lever))
            } else if key.hasPrefix("USD") {
                rate = CGFloat(100000) * num / (totalMoney * CGFloat(lever))
            } else if key.hasSuffix("USD") {
                rate = price * CGFloat(100000) * num / (totalMoney * CGFloat(lever))
            }
        } else {
            var otherKey = "\(NSString(string:key).substringToIndex(3))/USD"
            for cType in CURRENCT_ARRAY {
                if cType.key == otherKey {
                    rate = cType.price * CGFloat(100000) * num / (totalMoney * CGFloat(lever))
                }
            }
        }
    }
    
    func toJsonString() -> String {
        var dict = ["key":key, "value":value, "buyRate":rate, "lots": tradeNum, "operation": operation]
        var data = NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        var strJson=NSString(data: data!, encoding: NSUTF8StringEncoding)
        return strJson
    }
}
