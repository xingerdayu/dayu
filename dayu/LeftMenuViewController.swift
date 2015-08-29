//
//  LeftMenuViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/28.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class LeftMenuViewController: IIViewDeckController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle());
        
        var mainController = storyboard.instantiateViewControllerWithIdentifier("ucMainView") as UIViewController
        
        var leftController = storyboard.instantiateViewControllerWithIdentifier("ucLeftMenu")  as UIViewController;
        
        var containerController = IIViewDeckController(centerViewController: mainController, leftViewController: leftController)
        
        containerController.leftSize = 80;
        
        containerController.view.frame = self.view.bounds;
        self.view.addSubview(containerController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
