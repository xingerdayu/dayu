//
//  TopicListViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class TopicListViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate, WriteDelegete {
    
    private let FONT_SIZE:CGFloat = 15.0
    
    @IBOutlet weak var myTableView: UITableView!
    //@IBOutlet weak var titleLabel: UILabel!
    
    var refreshControl = UIRefreshControl()
    var topicList = NSMutableArray();
    var chooseIndexPath:NSIndexPath?
    
    var moreData = true
    
    var group:Group!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //self.automaticallyAdjustsScrollViewInsets = false
        //self.navigationController?.navigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer!.enabled = true

        //myTableView.registerNib(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: identifier)
        //添加长按手势识别
        //addLongPressGesture()   //暂时先不添加手势识别
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "加载更多")
        refreshControl.frame.size = CGSizeMake(320 * app.autoSizeScaleX, 20)
        myTableView.addSubview(refreshControl)
        
        //titleLabel.text = group.name

        refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if chooseIndexPath != nil {
            print(topicList[chooseIndexPath!.row] as! Topic)
            myTableView.reloadRowsAtIndexPaths([chooseIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
            //滑到底部加载更多
            if moreData {
                getTopicList(1);
            }
        }
    }
    
    func refreshData() {
        getTopicList(0)
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getTopicList(stat:Int) {
        let params = ["token":app.getToken(), "groupId":group.id] as NSMutableDictionary
        
        if stat == 1 && topicList.count > 0{
            params["minTopicId"] = (topicList.lastObject as! Topic).id
        }
        HttpUtil.post(URLConstants.getGroupOrUserTopicsUrl, params: params, success: {(response:AnyObject!) in
            self.refreshControl.endRefreshing()
            //println(response)
            //if response["stat"] as String == "OK" {
                let array = response["topics"] as! NSArray
                if array.count > 0 && stat == 0 {
                    self.moreData = true
                    self.topicList.removeAllObjects()
                }
                if array.count == 0 && stat == 1 {
                    ViewUtil.showToast(self.view, text: "没有更多了", afterDelay: 1)
                    self.moreData = false
                }
                for item in array{
                    self.topicList.addObject(Topic.parseTopic(item as! NSDictionary))
                }
                self.myTableView.reloadData()
            //}
            }, failure:{(error:NSError!) in
                self.refreshControl.endRefreshing()
                print(error.localizedDescription)
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let topic = topicList[indexPath.row] as! Topic
        
        let cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.viewWithTag(5)?.removeFromSuperview() //TODO 这里不使用IOS自带的缓存，可能性能有影响，但是注意不要重复添加view，不然会有重叠
        cell.viewWithTag(6)?.removeFromSuperview()
        
        let topicView = NSBundle.mainBundle().loadNibNamed("TopicView", owner: self, options: nil)[0] as! TopicView
        topicView.tag = 5
        topicView.setTopic(topic)
        cell.addSubview(topicView)
        
        let itemsView = NSBundle.mainBundle().loadNibNamed("ItemsView", owner: self, options: nil)[0] as! ItemsView
        itemsView.frame = CGRectMake(10, (topicView.frame.height - 35) , 300, 30)
        itemsView.setTopicValue(topic)
        itemsView.tag = 6
        myAutoLayout(itemsView)
        cell.addSubview(itemsView)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let topic = topicList[indexPath.row] as! Topic
        return topic.getAllHeight(true) + 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.chooseIndexPath = indexPath
        let topic = topicList[indexPath.row] as! Topic
        let usb = UIStoryboard(name: "Group", bundle: NSBundle.mainBundle())
        let replyVc = usb.instantiateViewControllerWithIdentifier("ReplyListControllerUI") as! ReplyListViewController
        replyVc.topic = topic
        self.navigationController?.pushViewController(replyVc, animated: true)

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }
    
    @IBAction func post(sender: AnyObject) {
        let usb = UIStoryboard(name: "Group", bundle: NSBundle.mainBundle())
        let writeVc = usb.instantiateViewControllerWithIdentifier("WriteViewUI") as! WriteViewController
        writeVc.group = group
        writeVc.delegate = self
        self.navigationController?.pushViewController(writeVc, animated: true)
    }
    
    func onWriteFinished() {
        refreshData()
    }
}
