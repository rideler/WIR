//
//  User.swift
//  WIT
//
//  Created by Shay Kremer on 2/25/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
import Firebase
class UserAuth{
    
    init(){
        // Use Firebase library to configure APIs
        FIRApp.configure()
    }
    
    func register(email:String, pwd:String, callback:@escaping (Bool)->Void){
        FIRAuth.auth()?.createUser(withEmail: email, password: pwd) { (user, error) in
            if error != nil{
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    
    func login(email:String, pwd:String, callback:@escaping (Bool)->Void){
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd) { (user, error) in
            if error != nil{
                print("\(error)")
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    
    func logout(callback:@escaping (Bool)->Void){
        do {
            try FIRAuth.auth()?.signOut()
            callback(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func isLogedIn()->Bool{
        //let userId = FIRAuth.auth()?.currentUser?.uid
        return (FIRAuth.auth()?.currentUser != nil)
    }
    
    func getUserId()->String{
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
}
