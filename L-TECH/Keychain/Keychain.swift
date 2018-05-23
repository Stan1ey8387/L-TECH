//
//  Keychain.swift
//  L-TECH
//
//  Created by Захар Бабкин on 22/05/2018.
//  Copyright © 2018 Захар Бабкин. All rights reserved.
//

import Foundation
import Security

fileprivate let userAccount = "AuthenticatedUser"

fileprivate let phoneKey = "KeyForPhone"
fileprivate let passwordKey = "KeyForPassword"


fileprivate let kSecClassValue = NSString(format: kSecClass)
fileprivate let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
fileprivate let kSecValueDataValue = NSString(format: kSecValueData)
fileprivate let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
fileprivate let kSecAttrServiceValue = NSString(format: kSecAttrService)
fileprivate let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
fileprivate let kSecReturnDataValue = NSString(format: kSecReturnData)
fileprivate let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)


final class Keychain {
    
    enum AuthInfoType {
        case phone
        case password
    }
    
    static let shared = Keychain()
    
    
    func save(_ authInfoType: AuthInfoType, info: String ) {
        switch authInfoType {
            case .phone:     self.save(service: phoneKey, data: info)
            case .password:  self.save(service: passwordKey, data: info)
        }
    }
    
    func load(_ authInfoType: AuthInfoType) -> String? {
        switch authInfoType {
            case .phone:     return self.load(service: phoneKey)
            case .password:  return self.load(service: passwordKey)
        }
    }
    
    private func save(service: String, data: String) {
        guard let dataFromString = data.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue), allowLossyConversion: false) else {return}
        
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        SecItemDelete(keychainQuery as CFDictionary)
        
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private func load(service: String) -> String? {
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = String(data: retrievedData as Data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            }
        }
        
        return contentsOfKeychain
    }
}
