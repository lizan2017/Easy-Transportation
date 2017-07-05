//
//  profileController.swift
//  GMaps
//
//  Created by Lizan Pradhanang on 7/5/17.
//  Copyright © 2017 Lizan. All rights reserved.
//

import Foundation
import Firebase

class ProfileController{
    func updateProfileImage(userName:String, image:Data, UID: String, completion: @escaping (Bool) -> ()){
        let storageRef = FIRStorage.storage().reference().child(userName).child("image.png")
        storageRef.delete(completion: nil)
        storageRef.put(image, metadata: nil, completion: {
            (metadata, error) in
            let databaseRef = FIRDatabase.database().reference().child("Users").child(UID).child("ImageUrl")
            databaseRef.setValue("\(metadata!.downloadURLs![0])")
            completion(true)
        })
    }
    
    func updateUserEmail(userEmail:String, UID:String, completion: @escaping (Bool) -> ()){
        FIRAuth.auth()?.currentUser?.updateEmail(userEmail, completion: {
            (user) in
            let databaseRef = FIRDatabase.database().reference().child("Users").child(UID).child("Email")
            databaseRef.setValue(userEmail)
            completion(true)
        })
        
    }
    
    func logout(completion: @escaping (Bool) -> ()){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchData = try! context.fetch(LoginData.fetchRequest())
        for i:Int in 0 ..< fetchData.count{
            let data = fetchData[i] as! LoginData
            context.delete(data)
            try! context.save()
        }
        completion(true)
    }
    
    func updateUserName(userName:String, UID:String, completion: @escaping (Bool) -> ()){
        let databaseRef = FIRDatabase.database().reference().child("Users").child(UID).child("Full Name")
        databaseRef.setValue(userName)
        completion(true)
        
        
    }
}

