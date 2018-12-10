//
//  PostQuestionVC.swift
//  University
//
//  Created by 肖权 on 2018/11/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka
import ImageRow
import Toast_Swift

class PostQuestionVC: FormViewController {
    
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
                if question == nil {
                    doPost()
                } else {
                    doPatch()
                }
            default:
                print("错误类型")
                
            }
        }
        get {
            return -1
        }
    }
    
    var question: Question?

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
        
    }
    
    private func initUI() {
        if question == nil {
            title = "提出问题"
        } else {
            title = "更新问题"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    private func initForm() {
        form +++ Section("问题基本信息")
            <<< TextRow(){ row in
                row.title = "问题"
                row.value = question?.title
                row.placeholder = "简要描述问题"
                row.add(rule: RuleRequired(msg: "问题不能为空"))
                row.add(rule: RuleMaxLength(maxLength: 25, msg: "问题需小于25字"))
                row.tag = "title"
                }.cellUpdate { [weak self] cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        guard let self = self else {
                            return
                        }
                        let errors = row.validationErrors.first?.msg
                        self.view.makeToast(errors, position: .top)
                    }
            }
            <<< TextRow() {
                $0.title = "类型"
                $0.value = question?.type
                $0.placeholder = "生活、学习、科技..."
                $0.add(rule: RuleRequired(msg: "类型不能为空"))
                $0.add(rule: RuleMaxLength(maxLength: 4, msg: "类型需小于4字"))
                $0.tag = "type"
                }.cellUpdate { [weak self] cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        guard let self = self else {
                            return
                        }
                        let errors = row.validationErrors.first?.msg
                        self.view.makeToast(errors, position: .top)
                    }
            }
            
            <<< TextRow() {
                $0.title = "来源"
                $0.value = question?.from
                $0.placeholder = "问题来自哪里..."
                $0.add(rule: RuleRequired(msg: "来源不能为空"))
                $0.add(rule: RuleMaxLength(maxLength: 5, msg: "来源需小于5字"))
                $0.tag = "from"
                }.cellUpdate { [weak self] cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                        guard let self = self else {
                            return
                        }
                        let errors = row.validationErrors.first?.msg
                        self.view.makeToast(errors, position: .top)
                    }
                }
    }
    
    @objc private func submit() {
        let errors = form.validate()
        if errors.count == 0 {
            print("验证成功")
            checkUserStatus()
        } else {
            self.view.makeToast("问题格式错误，请检查红色标记", position: .top)
            print("验证失败")
        }
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
    
    private func doPost() {        
        var parameters: Parameters = form.values() as Parameters
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/question", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    // 发布成功
                    self.view.makeToast("提问成功，返回查看问题", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    self.view.makeToast("提问失败，请稍后再试", position: .top)
                    print(error)
                }
            }
        }
    }
    
    private func doPatch() {
        var parameters: Parameters = form.values() as Parameters
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/question/\(question?.id ?? 0)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    self.view.makeToast("更新问题成功，返回查看问题", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    self.view.makeToast("更新问题失败，请稍后再试", position: .top)
                    print(error)
                }
            }
        }
    }
}
