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

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    var type: String = "Essay"
    var commentID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()        
    }
    
    private func initUI() {
        title = "发表评论"
    }
    
    private func doPost(_ content: String) {
        // From的tag为post参数的名称
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "commentID": commentID,
            "type": type,
            "content": content
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/comment", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    // 发布成功
                    self.view.makeToast("评论成功，点击右下角去看看吧~", position: .top)
                case .failure(let error):
                    self.view.makeToast("评论失败，稍后再试", position: .top)
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    
    @IBAction func sendComment(_ sender: UIButton) {
        let content = commentTextView.text.trimmingCharacters(in: .whitespaces)
        if content == "" {
            view.makeToast("请输入评论", position: .top)
            return
        }
        if content.count > 50 {
            view.makeToast("限制50字以内", position: .top)
            return
        }
        
        // 发布评论
        doPost(content)
    }
    
    @IBAction func exitKeyboard(_ sender: UITapGestureRecognizer) {
        commentTextView.resignFirstResponder()
    }
    
    
}
