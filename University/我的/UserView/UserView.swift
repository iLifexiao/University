//
//  UserView.swift
//  University
//
//  Created by 肖权 on 2018/10/25.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol UserViewDelegate {
    func userViewFuncClick(_ funcName: String)
}

class UserView: UIView {

    @IBOutlet weak var userBGImageView: UIImageView!
    @IBOutlet weak var userHeadImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var essayButton: UIButton!
    @IBOutlet weak var fansButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var redDotLabel: UILabel!
    @IBOutlet weak var essayLabel: UILabel!
    @IBOutlet weak var fansLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    
    weak var delegate: UserViewDelegate?
    
    func setUserBGImage(_ bgImage: UIImage?) {
        userBGImageView.image = bgImage
    }
    
    func setUserHead(_ head: String?) {
        guard let head = head else {
            return
        }
        userHeadImageView.sd_setImage(with: URL(string: baseURL + head), completed: nil)
    }
    
    func setUserName(_ name: String?) {
        guard let name = name else {
            return
        }
        userNameLabel.text = name
    }
    
    func setUnreadMessage(count: Int) {
        if count != 0 {
            redDotLabel.isHidden = false
            if count <= 99 {
                redDotLabel.text = String(count)
            } else {
                redDotLabel.text = "99+"
            }
        } else {
            redDotLabel.isHidden = true
        }
    }
    
    func setMessageCount(_ count: Int?) {
        guard count != nil else { return }
        messageLabel.text = String(count!)
    }
    
    func setEssayCount(_ count: Int?) {
        guard count != nil else { return }
        essayLabel.text = String(count!)
    }
    
    func setFansCount(_ count: Int?) {
        guard count != nil else { return }
        fansLabel.text = String(count!)
    }
    
    func setCollectionCount(_ count: Int?) {
        guard count != nil else { return }
        collectionLabel.text = String(count!)
    }
    
    @IBAction func funcPress(_ sender: UIButton) {
        var funcName = ""
        switch sender.tag {
        case 40001:
            funcName = "私信"
        case 40002:
            funcName = "文章"
        case 40003:
            funcName = "粉丝"
        case 40004:
            funcName = "收藏"
        default:
            funcName = ""
        }
        
        if let delegate = self.delegate {
            delegate.userViewFuncClick(funcName)
        }
    }
    
    
    
}
