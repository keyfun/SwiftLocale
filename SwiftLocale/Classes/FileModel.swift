//
//  FileModel.swift
//  SwiftLocale_Example
//
//  Created by Key Hui on 6/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

public class FileModel {

    public var locale = ""
    public var filePath = ""
    public var data: [String: String] =  [:]

    public init(data: [String: String]) {
        locale = data["locale"] ?? ""
        filePath = data["file_path"] ?? ""
    }
    
    public func setData(data: [String: String]) {
        self.data = data
    }

    public func toString() -> String {
        let format = "locale = %@, filePath = %@\ndata = %@"
        return String(format: format, locale, filePath, data)
    }
    
    public func printString() {
        print(toString())
    }
}
