//
//  PostSQL.swift
//  WIT
//
//  Created by Shay Kremer on 3/5/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation

class PostSQL {
    var database: OpaquePointer? = nil
    
    init?(){
        let dbFileName = "postSQL.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                return nil
            }
        }
        
        if Post.createTable(database: database) == false{
            return nil
        }
        if LastUpdateTable.createTable(database: database) == false{
            return nil
        }
    }
    
    func clear(){
        if Post.drop(database: database) == false{}
        if LastUpdateTable.drop(database: database) == false{}
        if Post.createTable(database: database) == false{}
        if LastUpdateTable.createTable(database: database) == false{}
    }
}
