//
//  FirebaseInfo.swift
//  petitami
//
//  Created by Marcelo Simim on 29/09/21.
//

import Foundation
import Firebase
import FirebaseStorage

struct Material {
    static func coverImage(unit number:Int)->StorageReference{
        return Storage.storage().reference(withPath: "cover/capa1.png")
    }
    
    static func exerciseImage(unit number:Int, exercise:Int)->StorageReference{
        return Storage.storage().reference(withPath: "exercises/unit\(number)/images/\(exercise).png")
    }
}
