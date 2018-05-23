//
//  String+InputMask.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation


extension String {
    func convertInputMask() -> String{
        var previesIsX = false
        var finalMask = ""
        
        for character in self {
            if character == "Х" && previesIsX == false {
                finalMask.append("[")
                finalMask.append(character)
                previesIsX = true
            } else if character != "Х" && previesIsX == true{
                finalMask.append("]")
                finalMask.append(character)
                previesIsX = false
            } else {
                finalMask.append(character)
            }
        }
        
        finalMask.append("]")
        
        return finalMask.replacingOccurrences(of: "Х", with: "0")
    }
    
    func cleanPhone() -> Int{
        var cleanPhone = ""
        
        for character in self {
            if Int("\(character)") != nil{
                cleanPhone.append(character)
            }
        }
        
        return Int(cleanPhone) ?? 0
    }
}
