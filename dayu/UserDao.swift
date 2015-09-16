//
//  UserDao.swift
//  dayu
//
//  Created by Xinger on 15/9/16.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import Foundation

class UserDao {
    
    //CREATE TABLE IF NOT EXISTS USERINFO (TEL TEXT, USER_ID TEXT, USERNAME TEXT, TOKEN TEXT, AUTHORITY TEXT, INTRO TEXT, REG_TIME TEXT)
    
    class func save(id:Int, tel:String, token:String, username:String?, intro:String?, regTime:Int64) {
        delete()
        let sql = "INSERT INTO USERINFO (TEL, USER_ID, USERNAME, TOKEN, AUTHORITY, INTRO, REG_TIME) VALUES (?,?,?,?,?,?,?)"
        
        var un = username == nil ? "" : username!
        var ito = intro == nil ? "" : intro!
        
        Db.executeSql(sql, arguments: [tel, id, un, token, 1, ito, "\(regTime)"])
    }
    
    class func save(id:Int, token:String) {
        let sql = "INSERT INTO USERINFO (USER_ID, TOKEN, AUTHORITY) VALUES (?,?,?)"
        Db.executeSql(sql, arguments: [id, token, 0])
    }
    
    class func get() -> User? {
        var user:User?
        let sql = "SELECT * FROM USERINFO"
        let db = Db.getDb()
        db.open()
        let rs = db.executeQuery(sql, withArgumentsInArray: [])
        while rs.next() {
            user = User()
            user?.id = Int(rs.longForColumn("USER_ID"))
            user?.tel = rs.stringForColumn("TEL")
            user?.token = rs.stringForColumn("TOKEN")
            user?.username = rs.stringForColumn("USERNAME")
            user?.authority = Int(rs.intForColumn("AUTHORITY"))
        }
        db.close()
        return user
    }
    
    class func delete() {
        let sql = "DELETE FROM USERINFO WHERE AUTHORITY=?"
        Db.executeSql(sql, arguments: [1])
    }
}