//
//  URLConstants.swift
//  Community
//
//  Created by Xinger on 15/3/15.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import Foundation

//let prefix = "http://112.74.85.171/"; //真实地址
//let URL_PREFIX = "http://112.74.85.171/Community";
//let URL_COMB = "http://120.24.96.69";

let URL_COMB = "http://192.168.1.101:8080"
let prefix = "http://192.168.1.104:8080/Community";  //测试地址
let URL_PREFIX = "http://192.168.1.104:8080/Community";

struct URLConstants {
    
    //=====user=====
    static let loginUrl = "\(URL_PREFIX)/user/login"
    
    static let registerUrl = "\(URL_PREFIX)/user/register"
    
    static let getTopUsersUrl = "\(URL_PREFIX)/user/top"
    
    static let payAttentionUrl = "\(URL_PREFIX)/user/follow"
    
    static let cancelAttenUrl = "\(URL_PREFIX)/user/cancelFollow"
    
    static let updateUserUrl = "\(URL_PREFIX)/user/update"
    
    static let getUserUrl = "\(URL_PREFIX)/user/get"
    
    static let guestUrl = "\(URL_PREFIX)/user/guest"
    
    static let getFollowUsersUrl = "\(URL_PREFIX)/user/followUsers"
    
    static let getCopyUsersUrl = "\(URL_PREFIX)/user/copyUsers"
    
    static let getGroupUsersUrl = "\(URL_PREFIX)/user/groupUsers"
    
    //=====group====
    static let getGroupsUrl = "\(URL_PREFIX)/group/list"
    
    static let createGroupUrl = "\(URL_PREFIX)/group/add"
    
    static let getJoinedGroupsUrl = "\(URL_PREFIX)/group/listJoined"
    
    static let applyForGroupUrl = "\(URL_PREFIX)/group/applyFor"
    
    static let agreeJoinGroupUrl = "\(URL_PREFIX)/group/join"
    
    static let getGroupInfoUrl = "\(URL_PREFIX)/group/info"
    
    static let quitGroupUrl = "\(URL_PREFIX)/group/quitGroup"
    
    //=====topic====
    static let postUrl = "\(URL_PREFIX)/topic/post"
    
    static let getTopicsUrl = "\(URL_PREFIX)/topic/pubList"
    
    static let reprintUrl = "\(URL_PREFIX)/topic/reprint"
    
    static let getGroupOrUserTopicsUrl = "\(URL_PREFIX)/topic/getList"
    
    static let supportTopicUrl = "\(URL_PREFIX)/topic/addAgree"
    
    static let cancelSupportTopicUrl = "\(URL_PREFIX)/topic/cancelAgree"
    
    static let getTopicUrl = "\(URL_PREFIX)/topic/get"
    
    static let deleteTopicUrl = "\(URL_PREFIX)/topic/delete"
    
    //=====reply====
    static let getReplysUrl = "\(URL_PREFIX)/reply/getList"
    
    static let addReplyUrl = "\(URL_PREFIX)/reply/add"
    
    //=====message====
    static let getMessagesUrl = "\(URL_PREFIX)/message/get"
    
    static let deleteMessageUrl = "\(URL_PREFIX)/message/delete"
    
    //=====course=====
    static let recommendCoursesUrl = "\(URL_PREFIX)/admin/web/course/recommend"
    
    static let newsUrl = "\(URL_PREFIX)/admin/web/news/getNews"
    
    //====suggest====
    static let suggestUrl = "\(URL_PREFIX)/suggest/add"
    
    static func getImageUrl(group:Group) -> String {
        if group.imagePath != nil {
            return "\(prefix)\(group.imagePath!)"
        }
        return "\(prefix)/upload/G/G\(group.id).jpg"
    }
    
    static func getTopicImageUrl(topic:Topic, i:Int) -> String {
        if topic.isShare > 0 {
            return "\(prefix)/upload/T/T\(topic.originId!)S\(i).jpg"
        } else {
            return "\(prefix)/upload/T/T\(topic.id)S\(i).jpg"
        }
    }
    
    static func getUserPhotoUrl(id:Int) -> String {
        return "\(prefix)/upload/U/U\(id).jpg"
    }
    
    static func getShareTopicUrl(topic:Topic) -> String {
        return "\(URL_PREFIX)/web/topic/\(topic.id)?shareCode=\(topic.shareCode)"
    }
    
    static func addCombinationUrl() -> String {
        return getSecondaryServerUrl() + "/combination/add"
    }
    
    static func adjustCombinationUrl() -> String {
        return getSecondaryServerUrl() + "/combination/adjust"
    }
    
    static func getSecondaryServerUrl() -> String {
        return "http://192.168.1.101:8080"
    }

    //====combination====
    static let getSortCombinationsUrl = "\(URL_COMB)/combination/sortlist"

    static let getCombinationDetialUrl = "\(URL_COMB)/combination/info"
    
    static let getCombinationWaveUrl = "\(URL_COMB)/combination/wave"
    
}