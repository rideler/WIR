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
//extension to string for using UTF8
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

//extension for Date
extension Date {
    //changes Date to epoch time in double
    func dateToDouble()->Double{
        return self.timeIntervalSince1970 * 1000
    }
    //changes date in string format to epoch time in double
    static func stringToDate(_ interval:String)->Date{
        return Date(timeIntervalSince1970: Double(interval)!)
    }
    //getting epoch time as double and changes it to Date
    static func doubleToDate(_ interval:Double)->Date{
        if (interval>9999999999){
            return Date(timeIntervalSince1970: interval/1000)
        }else{
            return Date(timeIntervalSince1970: interval)
        }
    }
    //set the print format for date
    var stringValue: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    
}

//The main Model class that bridges between the views to the other models
class Model{
    //initilazing all the models
    static let instance = Model()
    let userAuth: UserAuth? = UserAuth()
    let settingsSQL: SettingsSQL? = SettingsSQL()
    let postFB: PostlFireBase? = PostlFireBase()
    let postSQL: PostSQL? = PostSQL()
    let wit = Weather()
    let loc = Location()

    init() {    }
    
    //settings
    
    //change settings for model settings
    func changeSettings(stings:Settings){
        stings.changeSettingsToLocalDb(database: settingsSQL?.database)
    }
    //get settings for model settings
    func getSettings(callback:@escaping (Settings)->Void){
        //get settings from local DB
        let settings = Settings.getSettingsFromLocalDb(database: settingsSQL?.database)
            
            //return settings
        callback(settings)
    }
    
    
    // Authentication
    
    //registring new user
    func register(email:String, pwd:String, callback:@escaping (Bool)->Void){
        userAuth?.register(email: email, pwd: pwd, callback: callback)
    }
    //loging known user
    func login(email:String, pwd:String, callback:@escaping (Bool)->Void){
        userAuth?.login(email: email, pwd: pwd, callback: callback)
        
    }
    //loging out current user
    func logout(callback:@escaping (Bool)->Void){
        userAuth?.logout(callback: callback)
    }
    //checking if user is logged
    func isLogedIn()->Bool{
        return (userAuth?.isLogedIn())!
    }
    //getting logged user ID
    func getUserId()->String{
        return (userAuth?.getUserId())!
    }
    //getting logged user Name
    func getUserName()->String{
        return (userAuth?.getUserName())!
    }
    
    //local DB and firebase
    
    //clearing local data of posts
    func clear(){
        postSQL?.clear()
    }
    //add post to FB
    func addPost(ps:Post){
        postFB?.addPost(ps: ps){(error) in
            //print("\(error)")
        }
    }
    
    //getting all posts and notifyng about it
    func getAllPostsAndObserve(){
        // get last update date from SQL
        let lastUpdateDate = LastUpdateTable.getLastUpdateDate(database: postSQL?.database, table: (postSQL?.PS_TABLE)!)
        // get all updated records from firebase
        postFB?.getAllPostsAndObserve(lastUpdateDate, callback: { (posts) in
            //update the local db
            var lastUpdate:Date?
            for ps in posts{
                self.postSQL?.addPostToLocalDb(post: ps)
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
                LastUpdateTable.setLastUpdate(database: self.postSQL!.database, table: (self.postSQL?.PS_TABLE)!, lastUpdate: lastUpdate!)
            }
            
            //get the complete list from local DB
            let totalList = self.postSQL?.getAllPostsFromLocalDb()
            //let newList = totalList.sorted(by: {$0.lastUpdate! > $1.lastUpdate!})
            
            //return the list to the observers using notification center
            NotificationCenter.default.post(name: Notification.Name(rawValue:
                notifyPostListUpdate), object:nil , userInfo:["posts":totalList!])
        })
    }
    //saving image of post
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
    //getting image for post
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
    
    //saving image localy
    private func saveImageToFile(image:UIImage, name:String){
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    //getting the local path directory
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    //getting local image
    private func getImageFromFile(name:String)->UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(name)
        return UIImage(contentsOfFile:filename.path)
    }
    
    //weather
    
    //get answer about the weather
    func getWeather(country: String, city: String, startTime: Int, period: Int, pop: Int) -> Bool {
        return wit.getWeather(country: country, city: city, startTime: startTime, period: period, pop: pop)
    }
    
    //location
    
    //get 2D array of locations
    func getLocations() -> [[String]] {
        return loc.getLocations()
    }
    //get array of locations
    func getStringLocations() -> [String] {
        return loc.getStringLocations()
    }
    //getting row number of location
    func searchRowLocation(city:String,country:String) -> Int? {
        return loc.searchRow(city: city, country: country)
    }
    //get city by row number
    func getCity(row:Int) -> String{
        return loc.getCity(row: row)
    }
    //get country by row number
    func getCountry(row:Int) -> String{
        return loc.getCountry(row: row)
    }
}

























