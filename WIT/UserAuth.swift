//
//  User.swift
//  WIT
//
//  Created by Shay Kremer on 2/25/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
import Firebase
//The user autentication model
class UserAuth{
    
    init(){
        // Use Firebase library to configure APIs
        FIRApp.configure()
    }
    //registering new user and returing callback if it succed or not
    func register(email:String, pwd:String, callback:@escaping (Bool)->Void){
        //creating user in FB
        FIRAuth.auth()?.createUser(withEmail: email, password: pwd) { (user, error) in
            if error != nil{
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    //loging known user and returing callback if it succed or not
    func login(email:String, pwd:String, callback:@escaping (Bool)->Void){
        //checking with FB
        FIRAuth.auth()?.signIn(withEmail: email, password: pwd) { (user, error) in
            if error != nil{
                callback(false)
            }else{
                callback(true)
            }
        }
    }
    //loging out current user and returing callback if it succed or not
    func logout(callback:@escaping (Bool)->Void){
        do {
            try FIRAuth.auth()?.signOut()
            callback(true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //checking if user is logged using FB
    func isLogedIn()->Bool{
        return (FIRAuth.auth()?.currentUser != nil)
    }
    //getting current user ID from FB
    func getUserId()->String{
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    //getting current user name from DB
    func getUserName()->String{
        return (FIRAuth.auth()?.currentUser?.email!)!
    }
}
