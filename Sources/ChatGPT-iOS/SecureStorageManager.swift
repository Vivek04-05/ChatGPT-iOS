//
//  SecureStorageManager.swift
//
//
//  Created by Vivek Patel on 25/08/24.
//

import Foundation
import Security



class SecureStorageManager {
    
    static let shared = SecureStorageManager()
    
    private init() {}
    
    // Function for store data from Keychain
    func storeInKeychain(value: String, key: String){
        guard let data = value.data(using: .utf8) else {
            print("Failed to convert API key to data.")
            return
        }
        
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        deleteFromKeychain(key: key)  // This is optional 
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Successfully stored \(key) in Keychain.")

        } else {
            print("Failed to store \(key) in Keychain: \(status)")
        }
        
    }
    // Function for delete data from keychain
    
    func deleteFromKeychain(key: String) {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
    SecItemDelete(query as CFDictionary)
    }
    
    // Function for retrieve data from keychain
    
    func retrieveFromKeychain(key: String) -> String? {
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
