//
//  TopicListViewController.swift
//  dayu
//
//  Created by Xinger on 15/8/29.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import UIKit

class TopicListViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let FONT_SIZE:CGFloat = 15.0
    
    @IBOutlet weak var myTableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var topicList = NSMutableArray();
    
    var group:Group!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationController?.navigationBarHidden = true        
        self.navigationController?.interactivePopGestureRecognizer.enabled = true

        //myTableView.registerNib(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: identifier)
        //添加长按手势识别
        //addLongPressGesture()   //暂时先不添加手势识别
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "加载更多")
        refreshControl.frame.size = CGSizeMake(320, 20)
        myTableView.addSubview(refreshControl)

        refreshData()
    }
    
    func refreshData() {
        getTopicList()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func getTopicList() {
        var params = ["token":app.getToken(), "groupId":group.id]
        HttpUtil.post(URLConstants.getGroupOrUserTopicsUrl, params: params, success: {(response:AnyObject!) in
            self.refreshControl.endRefreshing()
            println(response)
            if response["stat"] as String == "OK" {
                var array = response["topics"] as NSArray
                if array.count > 0 {
                    self.topicList.removeAllObjects()
                }
                for item in array{
                    self.topicList.addObject(Topic.parseTopic(item as NSDictionary))
                }
                self.myTableView.reloadData()
            }
            }, failure:{(error:NSError!) in
                self.refreshControl.endRefreshing()
                println(error.localizedDescription)
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var topic = topicList[indexPath.row] as Topic
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TopicCell", forIndexPath: indexPath) as UITableViewCell
        
        var topicView = NSBundle.mainBundle().loadNibNamed("TopicView", owner: self, options: nil)[0] as TopicView
        topicView.setTopic(topic)
        cell.addSubview(topicView)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var topic = topicList[indexPath.row] as Topic
        return topic.getContentHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topicList.count
    }
}
