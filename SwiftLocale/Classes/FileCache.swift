//
//  FileCache.swift
//  SwiftLocale_Example
//
//  Created by Key Hui on 6/23/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Foundation

public typealias Completion = ([String: AnyObject]?, Error?) -> ()

public class FileCache {

    public static func download(remotePath: String, localPath: String, completion: @escaping Completion) {
        let remoteUrl = URL(string: remotePath)
        let localUrl = getDocumentUrl(localPath)
        download(remoteUrl: remoteUrl!, localUrl: localUrl, completion: completion)
    }

    public static func download(remoteUrl: URL, localUrl: URL, completion: @escaping Completion) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)

        print("remoteUrl = \(remoteUrl.absoluteString)")
        print("localUrl = \(localUrl.absoluteString)")

        let request = URLRequest(
            url: remoteUrl,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 15)

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("success: \(statusCode), remoteUrl = \(remoteUrl.absoluteString)")
                }

                do {
                    _ = try FileManager.default.replaceItemAt(localUrl, withItemAt: tempLocalUrl)
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                    completion(nil, writeError)
                }

                // get the file data
                loadFromDocument(localUrl, completion: completion)

            } else {
//                print("failure: \(error?.localizedDescription ?? "")")
                completion(nil, error)
            }
        }
        task.resume()
    }

    public static func loadFromDocument(_ path: String, completion: @escaping Completion) {
        let url = getDocumentUrl(path)
        loadFromDocument(url, completion: completion)
    }

    public static func loadFromDocument(_ url: URL, completion: @escaping Completion) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: url.path), options: .mappedIfSafe)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jsonObject = jsonObject as? Dictionary<String, AnyObject> {
//                print(jsonObject)
                completion(jsonObject, nil)
            }
        } catch {
//            print(error)
            completion(nil, error)
        }
    }

    public static func loadRemoteFile(_ path: String, completion: @escaping Completion) {
        let url = URL(string: path)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }

            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: AnyObject] {
//                print(responseJSON)
                completion(responseJSON, nil)
            }
        }

        task.resume()
    }

    public static func removeFile(_ path: String) {
        let url = URL(string: path)!
        removeFile(url)
    }

    public static func removeFile(_ url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print(error)
        }
    }

    public static func clearTempFolder(_ path: String) {
        let fileManager = FileManager.default
        let tempFolderPath = getDocumentUrl(path)
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath.path)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath.path + "/" + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }

    private static func getDocumentUrl(_ path: String) -> URL {
        let documentUrl = try! FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false)
        return documentUrl.appendingPathComponent(path)
    }

    public static func initConfig(path: String) {
        let target = getDocumentUrl(path)
        if !FileManager.default.fileExists(atPath: target.absoluteString) {
            print("\(target.path) not exists")
            do {
                try FileManager.default.createDirectory(
                    atPath: target.path,
                    withIntermediateDirectories: true,
                    attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    public static func replaceFiles(from: String, to: String) {
        let fromUrl = getDocumentUrl(from)
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: fromUrl.path)
            for filename in files {
                print("filename = \(filename)")
                let toUrl = getDocumentUrl(to + "/" + filename)
                let withUrl = fromUrl.appendingPathComponent(filename)
                print("toUrl = \(toUrl.path)")
                _ = try FileManager.default.replaceItemAt(toUrl, withItemAt: withUrl)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

}
