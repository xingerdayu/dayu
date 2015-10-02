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
    var ccomb:CComb!
    var adjust = false
    @IBOutlet weak var myCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if cyTypes == nil {
            cyTypes = CurrencyType.createCurrencys()
        }
        //myCollectionView.reloadData()
    }
    
    @IBAction func nextStep(sender: UIBarButtonItem) {
        if adjust {
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            let usb = UIStoryboard(name: "CComb", bundle: NSBundle.mainBundle())
            let lastVc = usb.instantiateViewControllerWithIdentifier("CCombStepThreeViewUI") as! CCombStepThreeViewController
            //lastVc.cyTypes = getChooseCurrencys()
            lastVc.ccomb = self.ccomb
            self.navigationController?.pushViewController(lastVc, animated: true)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let ct = cyTypes[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CurrencyItemUI", forIndexPath: indexPath) as UICollectionViewCell
        
        let bgView = cell.viewWithTag(10)
        let keyLabel = cell.viewWithTag(11) as! UILabel
        let valueLabel = cell.viewWithTag(12) as! UILabel
        
        keyLabel.text = ct.key
        keyLabel.text = ct.value
        
        if ct.isSelected {
            bgView?.backgroundColor = Colors.MainBlueColor
            keyLabel.textColor = UIColor.whiteColor()
            valueLabel.textColor = UIColor.whiteColor()
        } else {
            bgView?.backgroundColor = Colors.MyLightGrayColor
            keyLabel.textColor = Colors.WordMainBlueColor
            valueLabel.textColor = Colors.WordMainBlueColor
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cyTypes.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ct = cyTypes[indexPath.row]
        ct.isSelected = !ct.isSelected
        myCollectionView.reloadItemsAtIndexPaths([indexPath])
    }
    
}
