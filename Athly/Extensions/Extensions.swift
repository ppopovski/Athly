//
//  Extensions.swift
//  Athly
//
//  Created by Petar Popovski on 22.7.25.
//

import UIKit
import SwiftUI

protocol Storable {
    static var key: UserDefaultConstants.UserDefaultKey { get }
}

extension Storable where Self : Jsonable {
    func saveInUserDefaults() {
        UserDefaults.standard.set(self.toJson(), forKey: Self.key.rawValue)
    }
    
    static func readFromUserDefaults() -> Self? {
        if let value = UserDefaults.standard.string(forKey: Self.key.rawValue) {
            return Self.fromJsonString(value)
        }

        return nil
    }
    
    static func removeFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Self.key.rawValue)
    }
}

struct UserDefaultConstants {
    enum UserDefaultKey: String {
        case authTokens
        case currentUser
    }
}

protocol Jsonable {
    func toDictionary() -> [String : Any]?
    func toJson() -> String?
    static func fromJson(_ data: Data) -> Self?
    static func fromJsonString(_ string: String) -> Self?
}

extension Jsonable where Self : Codable {
    func toJson() -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        let result = String(decoding: data, as: UTF8.self)
        return result
    }
    
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        do {
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return dictionary
        } catch {
            print(error)
        }
        
        return nil
    }
    
    static func fromJson(_ data: Data) -> Self? {
        do {
            let decodedData = try JSONDecoder().decode(Self.self, from: data)
            return decodedData
        } catch {
            print("\(error)")
            return nil
        }
    }
}

extension Jsonable where Self : Codable {
    static func fromJsonString(_ string: String) -> Self? {
        guard let jsonData = string.data(using: .utf8) else { return nil }
        return Self.fromJson(jsonData)
    }
}

extension Jsonable {
    func toObject() -> Any {
        return toDictionary() as Any
    }
}

func Do(after delay: TimeInterval, animated: Bool = false, action: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        if animated {
            withAnimation {
                action()
            }
        } else {
            action()
        }
    }
}

public extension Optional {
    var isNil: Bool {
        guard case Optional.none = self else {
            return false
        }
        return true
    }

    var isSome: Bool {
        return !self.isNil
    }
}

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

