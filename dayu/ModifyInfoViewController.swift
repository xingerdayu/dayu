//
//  ModifyInfoViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/10.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class ModifyInfoViewController: UITableViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    var app = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var ivPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivPhoto.clipsToBounds = true
        ivPhoto.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let urlStr = URLConstants.getUserPhotoUrl(app.user.id)
        ivPhoto.sd_setImageWithURL(NSURL(string: urlStr), placeholderImage: UIImage(named: "user_default_photo.png"))
        
        nameLabel.text = app.user.getUsername()
        introLabel.text = app.user.getUserIntro()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 0 {
            chooseUploadType()
        } else if indexPath.row == 1 {
            let alertView = UIAlertView(title: "好名字会让鱼友们更容易记得您", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
            alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
            alertView.textFieldAtIndex(0)?.text = app.user.username
            alertView.delegate = self
            alertView.show()
        } else  {
            let usb = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc = usb.instantiateViewControllerWithIdentifier("ModifyIntroViewUI") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let nick = alertView.textFieldAtIndex(0)?.text
            if (nick?.isEmpty != nil) && nick!.isEmpty {
                ViewUtil.showToast(self.view, text: "用户名不能修改为空!", afterDelay: 1)
                return
            }
            let params = ["token":app.getToken(), "username":nick!]
            
            HttpUtil.post(URLConstants.updateUserUrl, params: params, success: {(response:AnyObject!) in
                    if response["stat"] as! String == "OK" {
                        self.app.user.username = nick
                        UserDao.modifyNick(nick!, id: self.app.user.id)
                        self.nameLabel.text = nick
                    }
                }
            )
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            getImageFromAlbum()
        } else if buttonIndex == 2 {
            getImageFromCamera()
        }
    }
    
    func getImageFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: {})
    }
    
    func getImageFromAlbum() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.navigationController?.presentViewController(imagePicker, animated: true, completion: {imagePicker in})
    }
    
    func chooseUploadType() {
        let actionSheet = UIActionSheet(title: "操作选项", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册中选", "相机拍照")
        
        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
        actionSheet.showInView(self.view)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.navigationController?.dismissViewControllerAnimated(false, completion: {})
        let chooseImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        //上传照片
        //获取UIImage NSData的方法
        let data = UIImagePNGRepresentation(chooseImage!)!
        let params = ["token": app.getToken()]
        HttpUtil.post(URLConstants.updateUserUrl, params: params, imageData: [data], success: {(response:AnyObject!) in
            if response["stat"] as! String == "OK" {
                let urlStr = URLConstants.getUserPhotoUrl(self.app.user.id)
                SDImageCache.sharedImageCache().removeImageForKey(urlStr)
                ViewUtil.showToast(self.view, text: "图像上传成功!", afterDelay: 1)
                self.onUploadSuccess(chooseImage)
            }
            }, failure: {(error:NSError!) in
                print(error.localizedDescription)
        })
    }
    
    func onUploadSuccess(chooseImage:UIImage?) {
        ivPhoto.image = chooseImage
    }
    
}
