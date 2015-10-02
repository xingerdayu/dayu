//
//  WriteViewController.swift
//  Community
//
//  Created by Xinger on 15/3/19.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

let MaxImageCount = 4

protocol WriteDelegete {
    func onWriteFinished();
}

class WriteViewController: BaseUIViewController, UITextViewDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, ELCImagePickerControllerDelegate {
    
    var group:Group?
    
    var delegate:WriteDelegete?
    
    @IBOutlet weak var contentText: UITextView!  //这个组件以后可以自己封装一下
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    
    var buttonList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //contentText.becomeFirstResponder()
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print("click = \(buttonIndex)")
        
        if buttonIndex == 1 {
            getImageFromAlbum()
        } else if buttonIndex == 2 {
            getImageFromCamera()
        }
    }
    
    //@的人暂时还没做，做了的话要把actionSheet的注释去掉
    @IBAction func addImage(sender: AnyObject) {
        //var actionSheet = UIActionSheet(title: "选择操作选项", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "相机", "相册")
//        var actionSheet = UIActionSheet(title: "操作选项", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册中选", "相机拍照")
//        
//        actionSheet.actionSheetStyle = UIActionSheetStyle.BlackTranslucent
//        actionSheet.showInView(self.view)
        getImageFromAlbum()
    }
    
    @IBAction func takePhoto(sender: AnyObject) {
        getImageFromCamera()
    }
    
    func getImageFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: {})
    }
    
    func getImageFromAlbum() {
        let albumController = ELCAlbumPickerController(style: UITableViewStyle.Plain)
        let imagePicker = ELCImagePickerController(rootViewController: albumController)
        imagePicker.maximumImagesCount = MaxImageCount - buttonList.count
        
        //imagePicker.returnsOriginalImage = true
        albumController.parent = imagePicker
        //imagePicker.mediaTypes = [kUTTypeImage, kUTTypeVideo]
        
        imagePicker.imagePickerDelegate = self
        self.presentViewController(imagePicker, animated: true, completion: {})
        
    }
    
    func elcImagePickerController(picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: {})
        
        for item in info {
            let dict = item as! NSDictionary
            let image = dict[UIImagePickerControllerOriginalImage] as! UIImage
            //var data = UIImagePNGRepresentation(tempImage)
            createButton(image)
        }
        setButtonGroupView()
    }
    
    func elcImagePickerControllerDidCancel(picker: ELCImagePickerController!) {
        picker.dismissViewControllerAnimated(true, completion: {})
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: {})
        createButton(image)
        setButtonGroupView()
    }
    
    func createButton(image:UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, forState: UIControlState.Normal)
        buttonList.addObject(button)
        button.addTarget(self, action: "deleteImage:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        //imageList.append(image)
        return button
    }
    
    func setButtonGroupView() {
        //这里限制只能上传4张图片
        for var i = 0; i < buttonList.count; i++ {
            let button = buttonList[i] as! UIButton
            //button.removeFromSuperview()
            button.frame = CGRectMake(CGFloat(10 + i * 65), 280, 60, 60)
            //self.view.addSubview(button)
        }
//        addBtn.setTranslatesAutoresizingMaskIntoConstraints(true) //清除 AutoLayout的影响
//        addBtn.frame.origin.x = CGFloat(10 + 65 * buttonList.count)
        
//        if buttonList.count < MaxImageCount {
//            addBtn.hidden = false
//        } else {
//            addBtn.hidden = true
//        }
    }
    
    func deleteImage(button:UIButton) {
        //hideFaceView()
        buttonList.removeObject(button)
        button.removeFromSuperview()
        
        setButtonGroupView()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func send(sender: AnyObject) {
        if contentText.text.isEmpty {
            ViewUtil.showAlertView("输入内容不能为空", view: self)
            return
        }
        let params = createParams()
        
        var dataList = Array<NSData>()
        for button in buttonList {
            let image = (button as! UIButton).imageForState(UIControlState.Normal)
            dataList.append(UIImageJPEGRepresentation(image!, 0.4)!)
        }
        let toast = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        HttpUtil.post(URLConstants.postUrl, params: params, imageData: dataList,
            success: {(response:AnyObject!) in
                print(response)
                
                if response["stat"] as! String == "OK" {
                    self.delegate?.onWriteFinished()
                    
                    ViewUtil.showToast(self.view, text: "帖子发表成功", afterDelay: 1)
                    
                    NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "cancel:", userInfo: nil, repeats: false)
                } else {
                    ViewUtil.showAlertView("发送失败!请重新尝试", view: self)
                }
                toast.hide(true)
            }, failure: {(error:NSError!) in
                toast.hide(true)
        })
    }
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        //self.view.endEditing(true)
//        contentText.resignFirstResponder()
//
//    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        contentText.resignFirstResponder()
    }
    
    func createParams() -> NSDictionary {
        //var username = app.user.username
        if group == nil {
            return ["token":app.getToken(), "username": app.user.getUsername(), "visible":"ALL", "content":contentText.text]
        } else {
            return ["token":app.getToken(), "username": app.user.getUsername(), "visible":"GROUP", "groupId":group!.id, "content":contentText.text]
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        changeLength()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        //hideFaceView()
    }
    
    func changeLength() {
        let length = (contentText.text as NSString).length
        wordLabel.text = "\(length)/500"
    }
    
    func onSelectedFace(str: String) {
        contentText.text = "\(contentText.text)\(str)"
        changeLength()
    }
    
    //集成了表情插件时需要用这个方法
    func onDeletedFace() {
        let content:NSString = contentText.text
        if content.length >= 2 {
            contentText.text = content.substringToIndex(content.length - 2)
            changeLength()
        }
    }
}
