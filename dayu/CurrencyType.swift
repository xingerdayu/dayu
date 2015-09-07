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


class CurrencyType : NSObject {
    
    var key:String!
    var value:String!
    var isSelected = false
    var operation = "SELL"
    var tradeNum:Float = 0
    var price:Float = 0
    
    class func createCurrencys() -> Array<CurrencyType> {
        var array = Array<CurrencyType>()
        for var i = 0; i < CURRENCY_TYPE_COUNT; i++ {
            var currencyType = CurrencyType()
            currencyType.key = CurrencyKeys[i]
            currencyType.value = CurrencyValues[i]
            array.append(currencyType)
        }
        return array
    }
}
