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

    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var textView: UITextView!

    let kServerPath = "http://localhost/JsonSample/"
//    let kServerPath = "http://localhost/JsonSampleNew/"
    let kRootFile = "version.json"

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = ""

        RemoteLocaleManager.shared.initConfig(
            cacheName: "SwiftLocaleDemo",
            serverPath: kServerPath,
            rootFile: kRootFile)

        startLoading()
        RemoteLocaleManager.shared.run { (response, error) in
//            print("response = \(response?.description ?? "nil")")
            DispatchQueue.main.async {
                self.textView.text = (response?.description)! + "\n"
                self.textView.text.append(RemoteLocaleManager.shared.getLocaleModel().toString())
            }
            self.stopLoading()
        }
    }

    private func startLoading() {
        DispatchQueue.main.async {
            self.textView.isHidden = true
            self.loader.isHidden = false
            self.loader.startAnimating()
        }
    }

    private func stopLoading() {
        DispatchQueue.main.async {
            self.textView.isHidden = false
            self.loader.isHidden = true
            self.loader.stopAnimating()
        }
    }

}

