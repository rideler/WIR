//
//  PostlFireBase.swift
//  WIT
//
//  Created by Shay Kremer on 3/5/17.
//  Copyright © 2017 Shay Kremer, Ron Naor. All rights reserved.
//


import Foundation
import Firebase
import FirebaseStorage

let NotifyDBChange = "NotifyDBChange"
//bridges between FB to Post
class PostlFireBase{
    
    //storage URL of FB
    lazy var storageRef = FIRStorage.storage().reference(forURL: "gs://will-it-rain-c26e3.appspot.com/")
    
    init(){
    }
    
    //add post to FB
    func addPost(ps:Post, completionBlock:@escaping (Error?)->Void){
        let ref = FIRDatabase.database().reference().child("posts").child(ps.id)
        ref.setValue(ps.toFirebase())
        ref.setValue(ps.toFirebase()){(error, dbref) in
            completionBlock(error)
        }
    }
    
    //getting all posts and notifying about it
    func getAllPostsAndObserve(_ lastUpdateDate:Date?, callback:@escaping ([Post])->Void){
        let handler = {(snapshot:FIRDataSnapshot) in
            var posts = [Post]()
            for child in snapshot.children.allObjects{
                if let childData = child as? FIRDataSnapshot{
                    if let json = childData.value as? Dictionary<String,Any>{
                        let ps = Post(json: json)
                        posts.append(ps)
                    }
                }
            }
            let newList = posts.sorted(by: {$0.lastUpdate! > $1.lastUpdate!})
            callback(newList)
        }
        
        let ref = FIRDatabase.database().reference().child("posts")
        if (lastUpdateDate != nil){
            let fbQuery = ref.queryOrdered(byChild:"lastUpdate").queryStarting(atValue:lastUpdateDate!.dateToDouble())
            fbQuery.observe(FIRDataEventType.value, with: handler)
        }else{
            ref.observe(FIRDataEventType.value, with: handler)
        }
    }
    //save image to FB and return url of the image stored or nil if failed
    func saveImageToFirebase(image:UIImage, name:(String), callback:@escaping (String?)->Void){
        let filesRef = storageRef.child(name)
        if let data = UIImageJPEGRepresentation(image, 0.8) {
            filesRef.put(data, metadata: nil) { metadata, error in
                if (error != nil) {
                    callback(nil)
                } else {
                    let downloadURL = metadata!.downloadURL()
                    callback(downloadURL?.absoluteString)
                }
            }
        }
    }
    //get image from FB
    func getImageFromFirebase(url:String, callback:@escaping (UIImage?)->Void){
        let ref = FIRStorage.storage().reference(forURL: url)
        ref.data(withMaxSize: 10000000, completion: {(data, error) in
            if (error == nil && data != nil){
                let image = UIImage(data: data!)
                callback(image)
            }else{
                callback(nil)
            }
        })
    }
    
}
