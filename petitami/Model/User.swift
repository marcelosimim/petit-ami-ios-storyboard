//
//  User.swift
//  petitami
//
//  Created by Marcelo Simim on 06/10/21.
//

import Foundation
import Firebase

struct User2{
    
    static var progress:Double = 0.0
    
    static func getUserUnit(uid:String)->Int{
        var unit = 0
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists{
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                print("Document data: \(dataDescription)")
                unit = document.data()?["current_unit"] as! Int
            }else{
                print("Document does not exist")
            }
        }
        
        return unit
    }
    
    static func getUserExercise(uid:String)->Int{
        var unit = 0
        Firestore.firestore().collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists{
                let dataDescription = document.data().map(String.init(describing: )) ?? "nil"
                print("Document data: \(dataDescription)")
                unit = document.data()?["current_exercise"] as! Int
            }else{
                print("Document does not exist")
            }
        }
        
        return unit
    }
    
    static func getProgress(){
            
    }
}
