//
//  Post.swift
//  WIT
//
//  Created by Shay Kremer on 3/5/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Post{
    
    static let PS_TABLE = "POSTS"
    static let PS_ID = "PS_ID"
    static let PS_USER = "PS_USER"
    static let PS_IMAGE_URL = "PS_IMAGE_URL"
    static let PS_LAST_UPDATE = "PS_LAST_UPDATE"
    static let PS_LOC = "PS_LOC"
    static let PS_DSC = "PS_DSC"
    
    var id:String
    var imageUrl:String
    var lastUpdate:Date?
    var dsc: String?
    var locate: String
    var user: String
    
    init(id:String, user:String, imageUrl:String, dsc: String? = nil, locate:String, lastUpdate:Double?){
        self.id = id
        self.user = user
        self.imageUrl = imageUrl
        self.dsc = dsc
        self.locate = locate
        if (lastUpdate != nil){
            self.lastUpdate = Date.doubleToDate(lastUpdate!)
        }
    }
    
    init(json:Dictionary<String,Any>){
        self.id = json["id"] as! String
        self.user = json["user"] as! String
        self.imageUrl = json["imageUrl"] as! String
        self.locate = json["location"] as! String
        if let ds = json["description"] as? String{
            self.dsc = ds
        }
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.doubleToDate(ts)
        }
    }
    
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id"] = self.id
        json["user"] = self.user
        json["imageUrl"] = self.imageUrl
        json["location"] = self.locate
        if (self.dsc != nil){
            json["description"] = self.dsc!
        }
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
    
    static func drop(database:OpaquePointer?){
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "DROP TABLE " + PS_TABLE + " ; " , nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
        }
    }
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + PS_TABLE + " ( " + PS_ID + " TEXT PRIMARY KEY, "
            + PS_USER + " TEXT, "
            + PS_IMAGE_URL + " TEXT, "
            + PS_LOC + " TEXT, "
            + PS_DSC + " TEXT, "
            + PS_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addPostToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Post.PS_TABLE
            + "(" + Post.PS_ID + ","
            + Post.PS_USER + ","
            + Post.PS_IMAGE_URL + ","
            + Post.PS_LOC + ","
            + Post.PS_DSC + ","
            + Post.PS_LAST_UPDATE + ") VALUES (?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let id = self.id.cString(using: .utf8)
            let user = self.user.cString(using: .utf8)
            let imageUrl = self.imageUrl.cString(using: .utf8)
            let locate = self.locate.cString(using: .utf8)
            var dsc = "".cString(using: .utf8)
            if self.dsc != nil {
                dsc = self.dsc!.cString(using: .utf8)
            }
            
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, user,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, imageUrl,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, locate,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, dsc,-1,nil);
            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 6, lastUpdate!.dateToDouble());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllPostsFromLocalDb(database:OpaquePointer?)->[Post]{
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
                print("read from filter st: \(psID) \(user) \(imageUrl)")
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
