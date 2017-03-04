//
//  Model.swift
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


class Model{
    
    static let instance = Model()
    var database: OpaquePointer? = nil
    let userAuth: UserAuth? = UserAuth()
    let settingsSQL: SettingsSQL? = SettingsSQL()
    init() {}
    

    func changeSettings(stings:Settings){
        stings.changeSettingsToLocalDb(database: self.database)
    }
    
    func getSettings(callback:@escaping (Settings)->Void){
        //get settings from local DB
        let settings = Settings.getSettingsFromLocalDb(database: self.database)
            
            //return settings
        callback(settings)
    }
    
    // Authentication
    
    func register(email:String, pwd:String, callback:@escaping (Bool)->Void){
        userAuth?.register(email: email, pwd: pwd, callback: callback)
    }
    
    func login(email:String, pwd:String, callback:@escaping (Bool)->Void){
        userAuth?.login(email: email, pwd: pwd, callback: callback)
        
    }
    
    func logout(callback:@escaping (Bool)->Void){
        userAuth?.logout(callback: callback)
    }
    
    func isLogedIn()->Bool{
        return (userAuth?.isLogedIn())!
    }

    func getUserId()->String{
        return (userAuth?.getUserId())!
    }
}

























