//
//  CCombStepOneViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/6.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class CCombStepOneViewController: BaseUIViewController {

    @IBOutlet weak var utfCombName: UITextField!
    @IBOutlet weak var utfCombIntro: UITextField!

    @IBOutlet weak var btnEvent: UILabel!
    @IBOutlet weak var btnModel: UILabel!
    @IBOutlet weak var btnTech: UILabel!
    @IBOutlet weak var btnNews: UILabel!
    
    var checkList = [false, false, false, false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func choose(sender: UITapGestureRecognizer) {
        var tag = sender.view!.tag - 1
        
        var btnList:[UILabel] = [btnEvent, btnModel, btnTech, btnNews]
        
        if checkList[tag] {
            checkList[tag] = false
            btnList[tag].backgroundColor = Colors.MyLightGrayColor
            btnList[tag].textColor = Colors.LargeBlackColor
        } else {
            checkList[tag] = true
            btnList[tag].backgroundColor = Colors.MainBlueColor
            btnList[tag].textColor = UIColor.whiteColor()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextStep(sender: AnyObject) {
        var usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
        var stepTwoVc = usb.instantiateViewControllerWithIdentifier("AddCombStepSecordUI") as UIViewController
        self.navigationController?.pushViewController(stepTwoVc, animated: true)
    }
    
    
}
