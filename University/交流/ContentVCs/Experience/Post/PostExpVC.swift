//
//  PostExpVC.swift
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

class PostExpVC: FormViewController {
    
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
                if experience == nil {
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
    
    var experience: Experience?

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
        if experience == nil {
            title = "传授经验"
        } else {
            title = "更新经验"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    private func initForm() {
        form +++ Section("经验的基本信息")
            <<< TextRow(){ row in
                row.title = "标题"
                row.value = experience?.title
                row.placeholder = "经验的标题"
                row.add(rule: RuleRequired(msg: "经验标题不能为空"))
                row.add(rule: RuleMaxLength(maxLength: 15, msg: "经验标题需小于15字"))
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
                $0.value = experience?.type
                $0.placeholder = "读书、日常、思考..."
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
            
            +++ Section("经验内容(支持MarkDown)")
            <<< TextAreaRow() {
                $0.value = experience?.content
                $0.placeholder = "## 让你的经验为他人照亮前方的道路"
                $0.add(rule: RuleRequired(msg: "内容不能为空"))
                $0.tag = "content"
                }.cellUpdate { [weak self] cell, row in
                    if !row.isValid {
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
            self.view.makeToast("经验格式错误，请检查红色标记", position: .top)
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
        // From的tag为post参数的名称
        var parameters: Parameters = form.values() as Parameters
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/experience", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    // 发布成功
                    self.view.makeToast("经验发布成功", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    self.view.makeToast("经验发布失败，稍后再试", position: .top)
                    print(error)
                }
            }
        }
    }
    
    private func doPatch() {
        // From的tag为post参数的名称
        var parameters: Parameters = form.values() as Parameters
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/experience/\(experience?.id ?? 0)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    self.view.makeToast("更新成功", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    self.view.makeToast("更新失败，稍后再试", position: .top)
                    print(error)
                }
            }
        }
    }
}
