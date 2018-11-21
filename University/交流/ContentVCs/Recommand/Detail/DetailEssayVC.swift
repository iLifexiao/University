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

    @IBOutlet weak var markdownView: MarkdownView!
    @IBOutlet weak var seeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    var essay: Essay?
    var likeCount: Int {
        set {
            likeCountLabel.text = String(newValue)
            essay?.likeCount = newValue
        }
        get {
            return essay?.likeCount ?? 0
        }
    }
    
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
        title = "文章内容"
        if let essay = essay {
            seeCountLabel.text = String(essay.readCount ?? 0)
            likeCountLabel.text = String(essay.likeCount ?? 0)
            commentLabel.text = String(essay.commentCount ?? 0)
            markdownView.load(markdown: essay.content)
        }
    }
    
    private func readCountIncrease() {
        guard let essay = essay else {
            return
        }
        Alamofire.request(baseURL + "/api/v1/essay/\(essay.id ?? 0)/read", method: .patch, headers: headers)
    }
    
    @IBAction func goComment(_ sender: UIButton) {
        
    }
    
    
    // MARK: 用户评论交互
    @IBAction func likeBtnPress(_ sender: UIButton) {
        guard let essay = essay else {
            return
        }
        if sender.isSelected {
            sender.isSelected = false
            likeCount -= 1
            sender.setImage(UIImage(named: "like_before"), for: .normal)
            Alamofire.request(baseURL + "/api/v1/essay/\(essay.id ?? 0)/unlike", method: .patch, headers: headers)
        } else {
            sender.isSelected = true
            likeCount += 1
            sender.setImage(UIImage(named: "like"), for: .normal)
            Alamofire.request(baseURL + "/api/v1/essay/\(essay.id ?? 0)/like", method: .patch, headers: headers)
        }
    }
    
    @IBAction func commentBtnPress(_ sender: UIButton) {
        guard let essay = essay else {
            view.makeToast("无可评论的内容", position: .top)
            return
        }
        let commentVC = CommentVC()
        commentVC.type = "Essay"
        commentVC.commentID = essay.id ?? 0
        navigationController?.pushViewController(commentVC, animated: true)
    }
    
}
