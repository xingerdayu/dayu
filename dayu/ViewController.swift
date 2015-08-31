//
//  ViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/27.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func jump1(sender: AnyObject) {
        var usb = UIStoryboard(name: "User", bundle: NSBundle.mainBundle())
        var vc = usb.instantiateViewControllerWithIdentifier("LoginController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func jump2(sender: AnyObject) {
        var usb = UIStoryboard(name: "CombList", bundle: NSBundle.mainBundle())
        var vc = usb.instantiateViewControllerWithIdentifier("CombListController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

