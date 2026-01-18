//
//  KeychainHelper.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import Foundation
import Security

struct KeychainKeys {
    static let authTokens = "authTokens"
}

class KeychainHelper {

    enum KeychainKeys: String {
        case authTokens
    }
    
    static func save<T: Codable>(_ object: T, forKey key: String) -> Bool {
        do {
            let data = try JSONEncoder().encode(object)
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecDuplicateItem {
                let updateQuery: [String: Any] = [kSecValueData as String: data]
                SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
                return true
            }
            
            return status == errSecSuccess
        } catch {
            print("Failed to encode object: \(error)")
            return false
        }
    }
    
    static func retrieve<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            do {
                let object = try JSONDecoder().decode(type, from: data)
                return object
            } catch {
                print("Failed to decode object: \(error)")
                return nil
            }
        }
        return nil
    }
    
    static func save(_ data: Data, forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            let updateQuery: [String: Any] = [kSecValueData as String: data]
            SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
            return true
        }
        
        return status == errSecSuccess
    }
    
    static func delete(forKey key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

