//
//  Validation.swift
//  petitami
//
//  Created by Marcelo Simim on 29/09/21.
//

import Foundation

struct Validation{
    
    static func notEmptyField(_ text:String)->Bool{
        return text != "" ? true : false
    }
    
    static func matchField(_ text1:String, _ text2:String)->Bool{
        return text1 == text2 ? true : false
    }
}
