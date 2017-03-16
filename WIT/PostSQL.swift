//
//  PostSQL.swift
//  WIT
//
//  Created by Shay Kremer on 3/5/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
//bridges between local DB to Post
class PostSQL {
    var database: OpaquePointer? = nil
    
    //parameters for SQL
     let PS_TABLE = "POSTS"
     let PS_ID = "PS_ID"
     let PS_USER = "PS_USER"
     let PS_IMAGE_URL = "PS_IMAGE_URL"
     let PS_LAST_UPDATE = "PS_LAST_UPDATE"
     let PS_LOC = "PS_LOC"
     let PS_DSC = "PS_DSC"
    //trying to open the local DB and if not exist creat it, also checks last update of the DB
    init?(){
        let dbFileName = "postSQL.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                return nil
            }
        }
        
        if self.createTable() == false{
            return nil
        }
        if LastUpdateTable.createTable(database: database) == false{
            return nil
        }
    }
    //clear local post data
    func clear(){
        //deletes DB
        if self.drop() == false{}
        //deletes last update
        if LastUpdateTable.drop(database: database) == false{}
        //create new empty table
        if self.createTable() == false{}
        //create new empty last update table
        if LastUpdateTable.createTable(database: database) == false{}
    }
    //delete the table
    private func drop()->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "DROP TABLE " + PS_TABLE + " ; " , nil, nil, &errormsg);
        if(res != 0){
            return false
        }
        else
        {
            return true
        }
    }
    //creates table
    private func createTable()->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + PS_TABLE + " ( " + PS_ID + " TEXT PRIMARY KEY, "
            + PS_USER + " TEXT, "
            + PS_IMAGE_URL + " TEXT, "
            + PS_LOC + " TEXT, "
            + PS_DSC + " TEXT, "
            + PS_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            return false
        }
        
        return true
    }
    //add post to local DB
    func addPostToLocalDb(post:Post){
        var sqlite3_stmt: OpaquePointer? = nil
        //build query using PostSQL parameters
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + PS_TABLE
            + "(" + PS_ID + ","
            + PS_USER + ","
            + PS_IMAGE_URL + ","
            + PS_LOC + ","
            + PS_DSC + ","
            + PS_LAST_UPDATE + ") VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            //converting parameters to utf8
            let id = post.id.cString(using: .utf8)
            let user = post.user.cString(using: .utf8)
            let imageUrl = post.imageUrl.cString(using: .utf8)
            let locate = post.locate.cString(using: .utf8)
            var dsc = "".cString(using: .utf8)
            if post.dsc != nil {
                dsc = post.dsc!.cString(using: .utf8)
            }
            //entering the value for the query
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, user,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, imageUrl,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, locate,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, dsc,-1,nil);
            if (post.lastUpdate == nil){
                post.lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 6, post.lastUpdate!.dateToDouble());
            //checks if the query succeeded
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                //print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    //getting all posts from localDB
    func getAllPostsFromLocalDb()->[Post]{
        var posts = [Post]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from POSTS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let psID =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let user =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let imageUrl =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                let locate =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                var dsc =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let update =  Double(sqlite3_column_double(sqlite3_stmt,5))
                if (dsc != nil && dsc == ""){
                    dsc = nil
                }
                let post = Post(id: psID!, user: user!, imageUrl: imageUrl!, dsc: dsc, locate: locate!, lastUpdate: update)
                posts.append(post)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return posts
    }

}
