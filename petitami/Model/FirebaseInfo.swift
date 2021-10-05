//
//  FirebaseInfo.swift
//  petitami
//
//  Created by Marcelo Simim on 29/09/21.
//

import Foundation
import Firebase
import FirebaseStorage

struct FirebaseRef {
    static let userRef = Firestore.firestore().collection("users")
    static let coverRef = Storage.storage().reference(withPath: "cover/capa1.png")
            /*coverRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                if let e = error {
                    print(e)
                }
                if let d = data{
                    self.coverImageView.image = UIImage(data: d)
                }
                
            }*/
}
