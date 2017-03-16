//
//  SettingsSQL.swift
//  WIT
//
//  Created by Shay Kremer on 3/4/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation

class SettingsSQL{
    var database: OpaquePointer? = nil
    
    init?(){
        let dbFileName = "databaseSettings.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                return nil
            }
        }
        
        if Settings.createTable(database: database) == false{
            return nil
        }
    }
}
























