//
//  BaseChooseImageViewController.swift
//  dayu
//
//  Created by Xinger on 15/9/10.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class BaseChooseImageViewController: BaseUIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print("click = \(buttonIndex)")
        
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
    
    /**
    NSString *const  UIImagePickerControllerMediaType ;指定用户选择的媒体类型（文章最后进行扩展）
    NSString *const  UIImagePickerControllerOriginalImage ;原始图片
    NSString *const  UIImagePickerControllerEditedImage ;修改后的图片
    NSString *const  UIImagePickerControllerCropRect ;裁剪尺寸
    NSString *const  UIImagePickerControllerMediaURL ;媒体的URL
    NSString *const  UIImagePickerControllerReferenceURL ;原件的URL
    NSString *const  UIImagePickerControllerMediaMetadata;当来数据来源是照相机的时候这个值才有效
    **/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.navigationController?.dismissViewControllerAnimated(false, completion: {})
        let chooseImage = info[UIImagePickerControllerEditedImage] as? UIImage
        
        //上传照片
        //获取UIImage NSData的方法
        let data = UIImagePNGRepresentation(chooseImage!)!
        let params = ["token": app.getToken()]
        HttpUtil.post(URLConstants.updateUserUrl, params: params, imageData: [data], success: {(response:AnyObject!) in
            print(response)
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
    }
}
