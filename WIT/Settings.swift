//
//  Settings.swift
//  WIT
//
//  Created by Shay Kremer on 2/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation

class Settings {
    static let SE_TABLE = "SETTINGS"
    static let SE_pop = "POP"
    static let SE_period = "PERIOD"
    static let SE_city = "CITY"
    static let SE_country = "COUNTRY"
    static let SE_id = "ID"
    
    let id:Int = 1
    var pop:Int
    var period:Int
    var city:String
    var country:String
    
    init(pop:Int, period:Int, city:String, country:String){
        self.pop = pop
        self.period = period
        self.city = city
        self.country = country
    }
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + SE_TABLE + " ( " + SE_id + " INT PRIMARY KEY, "
            + SE_pop + " INT, "
            + SE_period + " INT, "
            + SE_country + " TEXT, "
            + SE_city + " TEXT)",nil,nil, &errormsg);
        if(res != 0){
            return false
        }
        
        return true
    }
    
    func changeSettingsToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Settings.SE_TABLE
            + "(" + Settings.SE_id + ","
            + Settings.SE_pop + ","
            + Settings.SE_period + ","
            + Settings.SE_country + ","
            + Settings.SE_city + ") VALUES (?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            let new_id = self.id
            let new_pop = self.pop
            let new_period = self.period
            let new_country = self.country.cString(using: .utf8)
            let new_city = self.city.cString(using: .utf8)
            
            sqlite3_bind_int(sqlite3_stmt, 1, Int32(new_id));
            sqlite3_bind_int(sqlite3_stmt, 2, Int32(new_pop));
            sqlite3_bind_int(sqlite3_stmt, 3, Int32(new_period));
            sqlite3_bind_text(sqlite3_stmt, 4, new_country,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, new_city,-1,nil);
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
               //print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getSettingsFromLocalDb(database:OpaquePointer?)->Settings{
        var sqlite3_stmt: OpaquePointer? = nil
        var getSttings:Settings?
        if (sqlite3_prepare_v2(database,"SELECT * from SETTINGS;",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            if(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let getPop =  sqlite3_column_int(sqlite3_stmt,1)
                let getPeriod = sqlite3_column_int(sqlite3_stmt,2)
                let getCountry = String(validatingUTF8: sqlite3_column_text(sqlite3_stmt, 3))
                let getCity =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
            
            
                getSttings = Settings(pop: Int(getPop), period: Int(getPeriod), city: getCity!, country: getCountry!)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        if getSttings == nil{
            getSttings = Settings(pop: 35, period: 5, city: "Jerusalem", country: "israel")
        }
        return getSttings!
    }
}

