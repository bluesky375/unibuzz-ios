//
//  UBViewFileVC.swift
//  UniBuzz
//
//  Created by Gourav on 07/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class UBViewFileVC: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    var data: FileList?
    @IBOutlet weak var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = data, let name = data.note_type_name, let url = data.base_url {
            SVProgressHUD.show()
            titleLabel.text = name
            webView.uiDelegate = self
            webView.navigationDelegate = self
            webView.load(URLRequest(url: URL(string: url)!))
        }
        // Do any additional setup after loading the view.
    }

}

extension UBViewFileVC: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView!, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }

}
