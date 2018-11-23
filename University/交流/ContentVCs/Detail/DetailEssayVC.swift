//
//  DetailEssayVC.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import MarkdownView

class DetailEssayVC: UIViewController {

    lazy var markdownView = MarkdownView()
    lazy var commentView = Bundle.main.loadNibNamed("CommentView", owner: nil, options: nil)![0] as! CommentView

    
    // 作为显示的类别、API路径、替换if为switch提高性能
    var type: showType = .essay
    var id = 0
    
    // 可显示的类型
    // 采用枚举来处理不同类型的展示
    // 1. 避免多处修改
    // 2. 类型检查（比字符）
    // 3. 不会有意外类型（swith-default）
    enum showType {
        case essay
        case campusNews
        case experience
        case answer
        
        // 获取枚举对应的表名，用于评论标识
        var tableName: String {
            switch self {
            case .essay:
                return "Essay"
            case .campusNews:
                return "CampusNews"
            case .experience:
                return "Experience"
            case .answer:
                return "Answer"
            }
        }
        
        // 获取API对应的路径
        var apiName: String {
            switch self {
            case .essay:
                return "essay"
            case .campusNews:
                return "campusnews"
            case .experience:
                return "experience"
            case .answer:
                return "answer"
            }
        }
    }
    
    var essay: Essay?
    var compusNews: CampusNews?
    var experience: Experience?
    var answer: Answer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initData() {
        readCountIncrease()
    }
    
    private func initUI() {
        
        //TODO: 代码动态适配 safeArea / NSAutoLayout
        view.backgroundColor = .white
        markdownView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - TabBarHeight)
        commentView.frame = CGRect(x: 0, y: markdownView.frame.height, width: ScreenWidth, height: 50)
        commentView.delegate = self
        
        view.addSubview(markdownView)
        view.addSubview(commentView)
        
        switch type {
        case .essay:
            if let essay = essay {
                title = "文章内容"
                commentView.setupCommentViewData(readCount: essay.readCount ?? 0, likeCount: essay.likeCount ?? 0, commentCount: essay.commentCount ?? 0)
                markdownView.load(markdown: essay.content)
            }
        case .campusNews:
            if let compusNews = compusNews {
                title = "新闻详情"
                commentView.setupCommentViewData(readCount: compusNews.readCount ?? 0, likeCount: compusNews.likeCount ?? 0, commentCount: compusNews.commentCount ?? 0)
                markdownView.load(markdown: compusNews.content)
            }
        case .experience:
            if let experience = experience {
                title = "经验详情"
                commentView.setupCommentViewData(readCount: experience.readCount ?? 0, likeCount: experience.likeCount ?? 0, commentCount: experience.commentCount ?? 0)
                markdownView.load(markdown: experience.content)
            }
        case .answer:
            if let answer = answer {
                title = "回答详情"
                commentView.setupCommentViewData(readCount: answer.readCount ?? 0, likeCount: answer.likeCount ?? 0, commentCount: answer.commentCount ?? 0)
                markdownView.load(markdown: answer.content)
            }
        }
    }
    
    private func readCountIncrease() {
        // 设计API为类型标识，可以通过变量来访问不同的API
        Alamofire.request(baseURL + "/api/v1/\(type.apiName)/\(id)/read", method: .patch, headers: headers)
    }
}

// MARK: 用户交互[返回、写评论、点赞、看评论]
extension DetailEssayVC: CommentViewDelegate {
    func goBackBtnPress() {
        // presentingViewController，标识是否为present进来
        if presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func goCommentBtnPress() {
        let postCommentVC = PostCommentVC()
        postCommentVC.type = type.tableName
        postCommentVC.commentID = id
        
        if presentingViewController == nil {
            navigationController?.pushViewController(postCommentVC, animated: true)
        } else {
            self.present(postCommentVC, animated: true, completion: nil)
        }
    }
    
    func likeBtnPress(_ sender: UIButton) {
        if sender.isSelected {
            Alamofire.request(baseURL + "/api/v1/\(type.apiName)/\(id)/like", method: .patch, headers: headers)
        } else {
            Alamofire.request(baseURL + "/api/v1/\(type.apiName)/\(id)/unlike", method: .patch, headers: headers)
        }
    }
    
    func showComment() {
        let commentVC = CommentVC()
        commentVC.type = type.tableName
        commentVC.commentID = id
        
        if presentingViewController == nil {
            navigationController?.pushViewController(commentVC, animated: true)
        } else {
            self.present(commentVC, animated: true, completion: nil)
        }
    }
}
