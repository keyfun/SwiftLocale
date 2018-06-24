//
//  ViewController.swift
//  SwiftLocale
//
//  Created by Key Hui on 06/23/2018.
//  Copyright (c) 2018 Key Hui. All rights reserved.
//

import UIKit
import SwiftLocale

class ViewController: UIViewController {

    let kServerPath = "http://localhost/JsonSample/"
    let kRootFile = "version.json"

    override func viewDidLoad() {
        super.viewDidLoad()

        RemoteLocaleManager.shared.initConfig(
            cacheName: "SwiftLocaleDemo",
            serverPath: kServerPath,
            rootFile: kRootFile)

        RemoteLocaleManager.shared.run { (response, error) in
            print("response = \(response?.description ?? "nil")")
        }
    }

}

