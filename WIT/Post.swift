//
//  Post.swift
//  WIT
//
//  Created by Shay Kremer on 3/5/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//

import Foundation
import FirebaseDatabase

//model defines how post is built
class Post{
    
    var id:String
    var imageUrl:String
    var lastUpdate:Date?
    var dsc: String?
    var locate: String
    var user: String
    
    init(id:String, user:String, imageUrl:String, dsc: String? = nil, locate:String, lastUpdate:Double?){
        self.id = id
        self.user = user
        self.imageUrl = imageUrl
        self.dsc = dsc
        self.locate = locate
        if (lastUpdate != nil){
            self.lastUpdate = Date.doubleToDate(lastUpdate!)
        }
    }
    //initilazing post parameters from json
    init(json:Dictionary<String,Any>){
        self.id = json["id"] as! String
        self.user = json["user"] as! String
        self.imageUrl = json["imageUrl"] as! String
        self.locate = json["location"] as! String
        if let ds = json["description"] as? String{
            self.dsc = ds
        }
        if let ts = json["lastUpdate"] as? Double{
            self.lastUpdate = Date.doubleToDate(ts)
        }
    }
    //building json for sending post to FB
    func toFirebase() -> Dictionary<String,Any> {
        var json = Dictionary<String,Any>()
        json["id"] = self.id
        json["user"] = self.user
        json["imageUrl"] = self.imageUrl
        json["location"] = self.locate
        if (self.dsc != nil){
            json["description"] = self.dsc!
        }
        json["lastUpdate"] = FIRServerValue.timestamp()
        return json
    }
    
    
    
}
