//
//  LibraryWebVC.swift
//  University
//
//  Created by 肖权 on 2018/11/12.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import WebKit

class LibraryWebVC: UIViewController {
    
    lazy var webView: WKWebView = {
        let web = WKWebView( frame: CGRect(x: 0, y: TopBarHeight, width: ScreenWidth, height:ScreenHeight - TopBarHeight))
        let url = NSURL(string: libraryURL)
        // 根据URL创建请求
        let requst = NSURLRequest(url: url! as URL)
        
        // 设置代理
        web.navigationDelegate = self
        web.load(requst as URLRequest)
        return web
    }()
    
    // 进度条
    lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = .green
        progress.trackTintColor = .clear
        return progress
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {        
        view.addSubview(self.webView)
        view.addSubview(self.progressView)
        
        self.progressView.frame = CGRect(x: 0,y: TopBarHeight, width: ScreenWidth, height: 2)
        self.progressView.isHidden = false
        UIView.animate(withDuration: 1.0) {
            self.progressView.progress = 0.0
        }
    }
}

extension LibraryWebVC: WKNavigationDelegate{
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
        title = "加载中..."
        /// 获取网页的progress
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
    }
    // 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!){
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!){
        /// 获取网页title
        self.title = self.webView.title
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 1.0
            self.progressView.isHidden = true
        }
    }
    
    // 页面加载失败时调用
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error){
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.progress = 0.0
            self.progressView.isHidden = true
        }
        
        // 弹出提示框点击确定返回
        let alertView = UIAlertController.init(title: "提示", message: "加载失败", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title:"确定", style: .default) { okAction in
            _ = self.navigationController?.popViewController(animated: true)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true, completion: nil)
    }
}
