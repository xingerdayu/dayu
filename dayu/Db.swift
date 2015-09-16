//
//  Db.swift
//  Community
//
//  Created by Xinger on 15/3/21.
//  Copyright (c) 2015年 Xinger. All rights reserved.
//

import Foundation

class Db {
    
    class func getDb() -> FMDatabase {
        let filemgr = NSFileManager.defaultManager()
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let docsDir = dirPaths[0] as String
        var databasePath = docsDir.stringByAppendingPathComponent("community.db")
        
        if !filemgr.fileExistsAtPath(databasePath) {
            let db = FMDatabase(path: databasePath)

            if db.open() {
                let user_sql = "CREATE TABLE IF NOT EXISTS USERINFO (TEL TEXT, USER_ID TEXT, USERNAME TEXT, TOKEN TEXT, AUTHORITY TEXT, INTRO TEXT, REG_TIME TEXT)"
                if !db.executeStatements(user_sql) {
                    println("Error: \(db.lastErrorMessage())")
                }
                db.close()
            } else {
                println("Error: \(db.lastErrorMessage())")
            }
        }
        let communityDB = FMDatabase(path: databasePath)
        return communityDB
    }
    
    class func executeSql(sql:String, arguments:[AnyObject]) {
        let db = Db.getDb()
        db.open()
        db.executeUpdate(sql, withArgumentsInArray: arguments)
        db.close()
    }
}