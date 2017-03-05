//
//  Model.swift
//  WIT
//
//  Created by Shay Kremer on 2/9/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//
//

import Foundation
import UIKit

let notifyPostListUpdate = "com.naor.NotifyPostListUpdate"

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

extension Date {
    
    func dateToDouble()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    
    static func stringToDate(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    
    static func doubleToDate(_ interval:Double)->Date{
        if (interval>9999999999){
            return Date(timeIntervalSince1970: interval/1000)
        }else{
            return Date(timeIntervalSince1970: interval)
        }
    }
    
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}


class Model{
    
    static let instance = Model()
    let userAuth: UserAuth? = UserAuth()
    let settingsSQL: SettingsSQL? = SettingsSQL()
    let postFB: PostlFireBase? = PostlFireBase()
    let postSQL: PostSQL? = PostSQL()
    init() {    }
    

    func changeSettings(stings:Settings){
        stings.changeSettingsToLocalDb(database: settingsSQL?.database)
    }
    
    func getSettings(callback:@escaping (Settings)->Void){
        //get settings from local DB
        let settings = Settings.getSettingsFromLocalDb(database: settingsSQL?.database)
            
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
    
    func getUserName()->String{
        return (userAuth?.getUserName())!
    }
    
    func clear(){
        postSQL?.clear()
    }
    
    func addPost(ps:Post){
        postFB?.addPost(ps: ps){(error) in
            print("\(error)")
        }
    }
    
//    func getPostById(id:String, callback:@escaping (Post)->Void){
//    }
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: postSQL?.database, table: Post.PS_TABLE)
        
        // get all updated records from firebase
        postFB?.getAllPosts(lastUpdateDate, callback: { (posts) in
            //update the local db
            print("got \(posts.count) new records from FB")
            var lastUpdate:Date?
            for ps in posts{
                ps.addPostToLocalDb(database: self.postSQL?.database)
                if lastUpdate == nil{
                    lastUpdate = ps.lastUpdate
                }else{
                    if lastUpdate!.compare(ps.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = ps.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.postSQL!.database, table: Post.PS_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Post.getAllPostsFromLocalDb(database: self.postSQL?.database)
            
            //return the list to the caller
            callback(totalList)
        })
    }
    
    func getAllPostsAndObserve(){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: postSQL?.database, table: Post.PS_TABLE)
        print("\(lastUpdateDate) = \(lastUpdateDate?.dateToDouble())")
        //lastUpdateDate = nil;
        // get all updated records from firebase
        postFB?.getAllPostsAndObserve(lastUpdateDate, callback: { (posts) in
            //update the local db
            print("got \(posts.count) new records from FB")
            var lastUpdate:Date?
            for ps in posts{
                ps.addPostToLocalDb(database: self.postSQL?.database)
                if lastUpdate == nil{
                    lastUpdate = ps.lastUpdate
                }else{
                    if lastUpdate!.compare(ps.lastUpdate!) == ComparisonResult.orderedAscending{
                        lastUpdate = ps.lastUpdate
                    }
                }
            }
            
            //upadte the last update table
            if (lastUpdate != nil){
                LastUpdateTable.setLastUpdate(database: self.postSQL!.database, table: Post.PS_TABLE, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = Post.getAllPostsFromLocalDb(database: self.postSQL?.database)
            
            //return the list to the observers using notification center
            NotificationCenter.default.post(name: Notification.Name(rawValue:
                notifyPostListUpdate), object:nil , userInfo:["posts":totalList])
        })
    }
    
    func saveImage(image:UIImage, name:String, callback:@escaping (String?)->Void){
        //1. save image to Firebase
        postFB?.saveImageToFirebase(image: image, name: name, callback: {(url) in
            if (url != nil){
                //2. save image localy
                self.saveImageToFile(image: image, name: name)
            }
            //3. notify the user on complete
            callback(url)
        })
    }
    
    func getImage(urlStr:String, callback:@escaping (UIImage?)->Void){
        //1. try to get the image from local store
        let url = URL(string: urlStr)
        let localImageName = url!.lastPathComponent
        if let image = self.getImageFromFile(name: localImageName){
            callback(image)
        }else{
            //2. get the image from Firebase
            postFB?.getImageFromFirebase(url: urlStr, callback: { (image) in
                if (image != nil){
                    //3. save the image localy
                    self.saveImageToFile(image: image!, name: localImageName)
                }
                //4. return the image to the user
                callback(image)
            })
        }
    }
    
    
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
 
}

























