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
    var questionID = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {
        title = "我的回答"
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
    
    @IBAction func submit(_ sender: UIButton) {
        let answer = answerTextView.text.trimmingCharacters(in: .whitespaces)
        if answer == "" {
            view.makeToast("回答不能为空", position: .top)
            return
        }
        doPost(answer)
    }
}
