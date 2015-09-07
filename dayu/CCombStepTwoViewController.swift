//
//  CCombStepTwoViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/7.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class CCombStepTwoViewController: BaseUIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var cyTypes:Array<CurrencyType>!
    @IBOutlet weak var myCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cyTypes = CurrencyType.createCurrencys()
        //myCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var ct = cyTypes[indexPath.row]
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("CurrencyItemUI", forIndexPath: indexPath) as UICollectionViewCell
        
        var bgView = cell.viewWithTag(10)
        var keyLabel = cell.viewWithTag(11) as UILabel
        var valueLabel = cell.viewWithTag(12) as UILabel
        
        keyLabel.text = ct.key
        keyLabel.text = ct.value
        
        if ct.isSelected {
            bgView?.backgroundColor = Colors.MainBlueColor
            keyLabel.textColor = UIColor.whiteColor()
            valueLabel.textColor = UIColor.whiteColor()
        } else {
            bgView?.backgroundColor = Colors.MyLightGrayColor
            keyLabel.textColor = Colors.MainBlueColor
            valueLabel.textColor = Colors.MainBlueColor
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cyTypes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var ct = cyTypes[indexPath.row]
        ct.isSelected = !ct.isSelected
        myCollectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
}
