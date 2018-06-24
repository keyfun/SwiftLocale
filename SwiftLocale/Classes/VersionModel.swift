//
//  VersionModel.swift
//  SwiftLocale_Example
//
//  Created by Key Hui on 6/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public struct VersionModel {

    public var updatedAt = ""
    public var files: Array<FileModel>!
    public var updatedDate: Date!

    public init() {
        files = Array<FileModel>()
        updatedDate = Date()
    }
    
    public init(data: [String: AnyObject]?) {
        if let updatedAt = data?["updated_at"] as? String {
            self.updatedAt = updatedAt
            self.updatedDate = getDate()
        }

        if let files = data?["files"] as? NSArray {
            self.files = files.map({ file -> FileModel in
                return FileModel(data: file as! [String: String])
            })
        } else {
            files = Array<FileModel>()
        }
    }

    private func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let date = dateFormatter.date(from: updatedAt)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from: components)
        return finalDate!
    }

    public func toString() -> String {
        var filesStr = ""

        files.forEach({ (file) in
            filesStr.append("\n" + file.toString() + "\n")
        })

        let format = "updatedAt= %@\nfiles: %@"
        return String(format: format, updatedAt, filesStr)
    }

    public func printString() {
        print(toString())
    }

}
