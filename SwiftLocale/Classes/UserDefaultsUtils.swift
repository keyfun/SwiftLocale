//
//  UserDefaultsUtils.swift
//  SwiftLocale
//
//  Created by Key Hui on 6/24/18.
//

import Foundation

struct UserDefaultsUtils {

    static let kCacheName = "cache_name"
    static let kServerPath = "server_path"
    static let kRootFile = "root_file"

    fileprivate static let userDefaults = UserDefaults.init(suiteName: "swift_locale")

    static func removeObject(key: String) {
        userDefaults?.removeObject(forKey: key)
    }

    static func save(_ key: String, value: String) {
        userDefaults?.set(value, forKey: key)
        userDefaults?.synchronize()
    }

    static func load(_ key: String, defaultValue: String) -> String {
        var tmpValue: String = ""
        if let value = userDefaults?.object(forKey: key) {
            tmpValue = value as! String
        } else {
            tmpValue = defaultValue
        }
        return tmpValue
    }

}
