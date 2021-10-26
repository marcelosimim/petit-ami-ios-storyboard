//
//  FirebaseInfo.swift
//  petitami
//
//  Created by Marcelo Simim on 29/09/21.
//

import Foundation
import Firebase
import FirebaseStorage

struct FirebaseData {
    
    //MARK: - Images
    
    static func coverImage(unit number:Int)->StorageReference{
        return Storage.storage().reference(withPath: "cover/capa\(number).png")
    }
    
    static func exerciseImage(unit number:Int, exercise:Int)->StorageReference{
        return Storage.storage().reference(withPath: "exercises/unit\(number)/images/\(exercise).png")
    }
    
    //MARK: - Collections
    
    static func exerciseCollection(unit number:Int, exercise:Int)->DocumentReference{
        return Firestore.firestore().collection("unit\(number)").document("e\(exercise)")
    }
    
    static func userCollection(uid:String)->DocumentReference{
        return Firestore.firestore().collection("users").document(uid)
    }
}
