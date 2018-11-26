//
//  PostAnswerVC.swift
//  University
//
//  Created by 肖权 on 2018/11/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class PostAnswerVC: UIViewController {
    
    @IBOutlet weak var answerTextView: UITextView!
    
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
                if answer == nil {
                    doPost(answerContent!)
                } else {
                    doPatch(answerContent!)
                }
            default:
                print("错误类型")
            }
        }
        get {
            return -1
        }
    }
    
    var questionID = 0
    var answerContent: String?
    var answer: Answer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {
        if answer == nil {
            title = "我的回答"
        } else {
            title = "更新回答"
            answerTextView.text = answer!.content
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        answerContent = answerTextView.text.trimmingCharacters(in: .whitespaces)
        if answerContent == "" {
            view.makeToast("回答不能为空", position: .top)
            return
        }
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
    
    private func doPost(_ content: String) {
        // From的tag为post参数的名称
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "questionID": questionID,
            "content": content
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/answer", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    // 发布相应
                    self.view.makeToast(json["message"].stringValue, position: .top)
                case .failure(let error):
                    self.view.makeToast("回答失败，稍后再试", position: .top)
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    private func doPatch(_ content: String) {
        // From的tag为post参数的名称
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "questionID": answer!.questionID,
            "content": content
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/answer/\(answer!.id ?? 0)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    self.view.makeToast("更新成功，返回刷新查看", position: .top)
                case .failure(let error):
                    self.view.makeToast("更新失败，稍后再试", position: .top)
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}
