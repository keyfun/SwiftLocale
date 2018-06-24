//
//  RemoteLocaleManager.swift
//  SwiftLocale
//
//  Created by Key Hui on 6/24/18.
//

public class RemoteLocaleManager {

    public static let shared = RemoteLocaleManager()
    private var cacheName = ""
    private var serverPath = ""
    private var rootFile = ""
    private var localVersion: VersionModel?
    private var remoteVersion: VersionModel?
    private var callback: Completion?

    private let successResult = ["result": true] as [String: AnyObject]

    public func initConfig(cacheName: String, serverPath: String, rootFile: String) {
        self.cacheName = cacheName
        self.serverPath = serverPath
        self.rootFile = rootFile

        saveConfig()

        // get local cache
        FileCache.loadFromDocument(rootFile) { (response, error) in
            if response != nil && error == nil {
                self.localVersion = VersionModel(data: response)
                self.localParse(versionModel: self.localVersion!)
            }
        }
    }

    private func loadConfig() {
        cacheName = UserDefaultsUtils.load(UserDefaultsUtils.kCacheName, defaultValue: "")
        serverPath = UserDefaultsUtils.load(UserDefaultsUtils.kServerPath, defaultValue: "")
        rootFile = UserDefaultsUtils.load(UserDefaultsUtils.kRootFile, defaultValue: "")
    }

    private func saveConfig() {
        UserDefaultsUtils.save(UserDefaultsUtils.kCacheName, value: cacheName)
        UserDefaultsUtils.save(UserDefaultsUtils.kServerPath, value: serverPath)
        UserDefaultsUtils.save(UserDefaultsUtils.kRootFile, value: rootFile)
    }

    public func run(completion: @escaping Completion) {
        callback = completion
        downloadVersionFile(rootFile, completion: {
            response, error in
            self.remoteVersion = VersionModel(data: response)

            // check if any new version
            if self.isValidUpdate() {
                self.remoteParse(versionModel: self.remoteVersion!)
            } else {
                self.callback?(self.successResult, nil)
                self.callback = nil
            }
        })
    }

    private func isValidUpdate() -> Bool {
        guard
            let localUpdatedDate = self.localVersion?.updatedDate,
            let remoteUpdatedDate = self.remoteVersion?.updatedDate else {
                return false
        }

//        print(localUpdatedDate, remoteUpdatedDate)
        if localUpdatedDate < remoteUpdatedDate {
            return true
        }

        return false
    }

    internal func downloadVersionFile(_ file: String, completion: @escaping Completion) {
        let remotePath = serverPath + file
        FileCache.download(remotePath: remotePath, localPath: file) { response, error in
            if response != nil && error == nil {
//                print("response = \(response?.description ?? "nil")")
                completion(response, nil)
            } else {
//                print("error = \(error?.localizedDescription ?? "nil")")
                completion(nil, error)
            }
        }
    }

    internal func downloadLocaleFile(_ file: String, completion: @escaping Completion) {
        let remotePath = serverPath + file
        FileCache.download(remotePath: remotePath, localPath: file) { response, error in
            if response != nil && error == nil {
//                print("response = \(response?.description ?? "nil")")
                completion(response, nil)
            } else {
//                print("error = \(error?.localizedDescription ?? "nil")")
                completion(nil, error)
            }
        }
    }

    private func localParse(versionModel: VersionModel) {
        versionModel.files.forEach { (file) in
            FileCache.loadFromDocument(file.filePath, completion: {
                response, error in
                if let data = response as? [String: String] {
                    file.setData(data: data)
                }
            })
        }
    }

    private func remoteParse(versionModel: VersionModel) {
        let size = versionModel.files.count
        var count = 0
        versionModel.files.forEach { (file) in
            RemoteLocaleManager.shared.downloadLocaleFile(file.filePath, completion: {
                response, error in
                if let data = response as? [String: String] {
                    file.setData(data: data)
                }
                count += 1

                if error != nil {
                    self.callback?(nil, error)
                    self.callback = nil
                    return
                }

                if count == size {
                    self.callback?(self.successResult, nil)
                    self.callback = nil
                }
            })
        }
    }

}