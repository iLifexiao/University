//
//  CommentView.swift
//  University
//
//  Created by 肖权 on 2018/11/22.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol CommentViewDelegate {
    func goBackBtnPress()
    func goCommentBtnPress()
    func likeBtnPress(_ sender: UIButton)
    func showComment()
}

class CommentView: UIView {
    
    @IBOutlet weak var readCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    weak var delegate: CommentViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: 公开方法
    func setupCommentViewData(readCount: Int, likeCount: Int, commentCount: Int) {
        readCountLabel.text = String(readCount + 1)
        likeCountLabel.text = String(likeCount)
        commentCountLabel.text = String(commentCount)
    }
    
    // 计算属性：这里仅仅获取like标签的值，不用关心数据源
    private var likeCount: Int {
        set {
            likeCountLabel.text = String(newValue)
        }
        get {
            return Int(likeCountLabel.text ?? "0") ?? 0
        }
    }
    
    // MARK: 按钮相应事件，由代理来相应
    @IBAction func backBtnPress(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }
        delegate.goBackBtnPress()
    }
    
    @IBAction func goCommentBtnPress(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }
        delegate.goCommentBtnPress()
    }
    
    @IBAction func likeBtnPress(_ sender: UIButton) {
        // UI改变
        if sender.isSelected {
            sender.isSelected = false
            likeCount -= 1
            sender.setImage(UIImage(named: "like_before"), for: .normal)
        } else {
            sender.isSelected = true
            likeCount += 1
            sender.setImage(UIImage(named: "like"), for: .normal)
        }
        
        // 网络请求交给代理
        guard let delegate = delegate else {
            return
        }
        delegate.likeBtnPress(sender)
    }
    
    @IBAction func showCommentBtnPress(_ sender: UIButton) {
        guard let delegate = delegate else {
            return
        }
        delegate.showComment()
    }
}
