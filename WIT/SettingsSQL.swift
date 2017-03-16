//
//  SettingsSQL.swift
//  WIT
//
//  Created by Shay Kremer on 3/4/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
//creates local DB for settings
class SettingsSQL{
    var database: OpaquePointer? = nil
    
    init?(){
        //DB name
        let dbFileName = "databaseSettings.db"
        //directory path where the DB will be created
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            //checking if DB already exist, if exist do nothing
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                return nil
            }
        }
        //checking if succed in creating table
        if Settings.createTable(database: database) == false{
            return nil
        }
    }
}
























