//
//  ModelSettings.swift
//  WIT
//
//  Created by Shay Kremer on 2/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//
//

import Foundation

extension String {
    public init?(validatingUTF8 cString: UnsafePointer<UInt8>) {
        if let (result, _) = String.decodeCString(cString, as: UTF8.self,
                                                  repairingInvalidCodeUnits: false) {
            self = result
        }
        else {
            return nil
        }
    }
}


class ModelSettings{
    static let instance = ModelSettings()
    var database: OpaquePointer? = nil
    
    init?(){
        let dbFileName = "databaseSettings.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return nil
            }
        }
        
        if Settings.createTable(database: database) == false{
            return nil
        }
    }
    

    func changeSettings(stings:Settings){
        stings.changeSettingsToLocalDb(database: self.database)
    }
    
    func getSettings(callback:@escaping (Settings)->Void){
        //get settings from local DB
        let settings = Settings.getSettingsFromLocalDb(database: self.database)
            
            //return settings
        callback(settings)
    }

}

























