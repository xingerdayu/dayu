//
//  FsLineView.swift
//  dayu
//
//  Created by 王毅东 on 15/9/12.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class FsLineView: UIView {
    var comb : Comb!
    var waveStyle : String!
    var pos = 0
    var crash : Float = 0
    var pointsX = Array<Int64>()
    var pointsY = Array<Float>()
    func createLineChart() {
//        var array = ["January", "February", "March", "April", "May", "June", "July"]
        var lineChart = FSLineChart(frame: CGRectMake(10, 35, 310, 160))
        
        lineChart.labelForIndex = {(item:UInt) in
            return StringUtil.formatTime(self.pointsX[Int(item)]).substringToIndex(10) //array[Int(item)]
        }
        
        lineChart.labelForValue = {(value:CGFloat) in
            //return "\(floor(value * 100) / 100)"
            return String(format: "%.2f", Float(value))
        }
        
        lineChart.setChartData(pointsY)
        self.addSubview(lineChart)
    }
    
    func getWave(comb:Comb!,waveStyle:String) {
        self.comb = comb
        self.waveStyle = waveStyle
        getLineData()
    }
    
    func getLineData() {
        var params = ["id":comb.id, "TIME" : waveStyle]
        HttpUtil.post(URLConstants.getCombinationWaveUrl, params: params, success: {(data:AnyObject!) in
            println("combs data = \(data)")
            if data["stat"] as String == "OK" {
                var item = data["combinations"] as NSDictionary
                var x = item["x"] as NSArray
                var y = item["y"] as NSArray
                self.pos = item["pos"] as Int
                self.crash = item["baocang"] as Float
                for i in 0..<self.pos {
                    self.pointsY.append(y[i] as Float)
                    var f = x[i] as Float
                    self.pointsX.append(Int64(f))
                }
                self.createLineChart()
            }
            }, failure:{(error:NSError!) in
                //TODO 处理异常
                println(error.localizedDescription)
        })
    }
}
