//
//  PostCommentVC.swift
//  University
//
//  Created by 肖权 on 2018/11/22.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class PostCommentVC: UIViewController {
    
    var content: String?
    
    private var userStatus: Int {
        set {
            switch newValue {
            case 0:
                if GlobalData.sharedInstance.userID == 0 {
                    view.makeToast("请先登录", position: .top)
                } else {
                    exitUser()
                    view.makeToast("帐号被封禁，请联系管理员", position: .top)
                }
            case 1:
                doPost(content!)
            default:
                print("错误类型")
                
            }
        }
        get {
            return -1
        }
    }

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    var type: String = "Essay"
    var commentID: Int = 0
    var preComment = ""
    /*
    typealias backValueBlock = (Comment) -> ()
    var sendBackValue: backValueBlock?
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()        
    }
    
    private func initUI() {
        if preComment == "" {
            title = "发表评论"
        } else {
            title = preComment
        }
    }
    
    private func doPost(_ content: String) {
        // From的tag为post参数的名称
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "commentID": commentID,
            "type": type,
            "content": preComment == "" ? content : (preComment + "：" + content)
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/comment", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    // 发布成功
                    self.view.makeToast("评论成功，返回查看吧~", position: .top)
                case .failure(let error):
                    self.view.makeToast("评论失败，稍后再试", position: .top)
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    
    @IBAction func sendComment(_ sender: UIButton) {
        content = commentTextView.text.trimmingCharacters(in: .whitespaces)
        if content == "" {
            view.makeToast("请输入评论", position: .top)
            return
        }
        if content!.count > 50 {
            view.makeToast("限制50字以内", position: .top)
            return
        }
        
        // 发布评论
        checkUserStatus()
    }
    
    public func checkUserStatus() {
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/userstatus", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.userStatus = json["status"].intValue
                print("json[status]: \(json["status"].intValue)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func exitKeyboard(_ sender: UITapGestureRecognizer) {
        commentTextView.resignFirstResponder()
    }
    
    
}
