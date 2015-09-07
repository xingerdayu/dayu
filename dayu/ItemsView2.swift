//
//  ItemsView2.swift
//  dayu
//
//  Created by Xinger on 15/9/4.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

protocol OnBackListener {
    func onBack()
}

class ItemsView2: ItemsView {
    
    var backDelegete:OnBackListener?
    
    @IBAction func back(sender: AnyObject) {
        backDelegete?.onBack()
    }
}
