//
//  PieView.swift
//  dayu
//
//  Created by 王毅东 on 15/9/10.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class PieView: UIView , UITableViewDataSource, UITabBarDelegate {
    
    var currencys = Array<Comb.Currency>()
    var comb : Comb!
    @IBOutlet weak var utvUnderPie: UITableView!
    @IBOutlet weak var pieView: PieView!
    var itemNum = 0
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    func createMagicPie(comb:Comb) {
        self.comb = comb
        currencys = comb.currencys
        let cell = UINib(nibName: "UnderPieItem", bundle: nil)
        self.utvUnderPie.registerNib(cell, forCellReuseIdentifier: "Cell")
        self.utvUnderPie.reloadData()
        itemNum = currencys.count % 2 == 0 ? (currencys.count/2) : (currencys.count/2 + 1)
        self.utvUnderPie.frame = CGRectMake(10+(app.ScreenWidth-320)/2, 230*app.autoSizeScaleY, 320, CGFloat(45 * itemNum)*app.autoSizeScaleY)
        if currencys.count > 0 {
            let pieLayer = PieLayer()
            pieLayer.frame = CGRectMake(0, 0, 180, 180)
            pieView.frame = CGRectMake(80+(app.ScreenWidth-320)/2, 42*app.autoSizeScaleY, 180, 180)
            var i = 0
//            var startOffset = 160 + (4 - dic.count) * 20
            for c in currencys {
                let str = Colors.currencyColor[c.key]!
                let color = StringUtil.colorWithHexString(str)
                pieLayer.addValues([PieElement(value: (c.buyRate), color: color)], animated: true)
//                var offset = startOffset + (i * 40)
//                var view = UIView(frame: CGRectMake(CGFloat(offset), 250, 5, 5))
//                view.backgroundColor = colorArr[i]
//                var label = UILabel(frame: CGRectMake(CGFloat(offset + 5), 250, 30, 5))
//                label.font = UIFont(name: "Arial", size: 7.0)
//                label.text = c.key as? String
//                addSubview(view)
//                addSubview(label)
                i++
            }
            pieView.layer.cornerRadius = 90
            pieView.clipsToBounds = true
            
            pieView.layer.addSublayer(pieLayer)
        }
//        else {
//            noLabel.hidden = false
//        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currencys.count % 2 == 0 ? (currencys.count/2) : (currencys.count/2 + 1))
        return itemNum
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath")
        var cs = Array<Comb.Currency>()
        let c1 = currencys[indexPath.row * 2] as Comb.Currency
        cs.append(c1)
        var c2 : Comb.Currency!
        if (currencys.count > indexPath.row * 2 + 1) {
            c2 = currencys[indexPath.row * 2 + 1] as Comb.Currency
            cs.append(c2)
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        var i = 0;
        for c in cs {
            let color = StringUtil.colorWithHexString(Colors.currencyColor[c.key]!)
            let dot = cell.viewWithTag(10 + i) as! UILabel
            dot.backgroundColor = color
            dot.layer.cornerRadius = 5
            dot.clipsToBounds = true
            if c.value != "可用保证金" {
                dot.text = c.operation == "SELL" ? "空" : "多"
                let pro = cell.viewWithTag(13 + i) as! UILabel
                pro.text = "当前盈亏$\(StringUtil.formatFloat(c.earning))"
            }
            let name = cell.viewWithTag(11 + i) as! UILabel
            name.text = c.value
            let percent = cell.viewWithTag(12 + i) as! UILabel
            percent.text = StringUtil.formatFloat(c.buyRate * 100) + "%"
            percent.textColor = color
            i = 10
        }
        return cell
    }
    
    
}