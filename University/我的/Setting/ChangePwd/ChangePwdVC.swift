//
//  ChangePwdVC.swift
//  University
//
//  Created by 肖权 on 2018/11/25.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON
import Eureka
import ImageRow
import Toast_Swift

class ChangePwdVC: FormViewController {
    
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
        title = "修改密码"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    private func initForm() {
        form +++ Section("完成以下的基本流程")
            <<< AccountRow() {row in
                row.title = "帐号"
                row.placeholder = "请输入帐号"
                row.add(rule: RuleRequired(msg: "帐号不能为空"))
                row.tag = "account"
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
            <<< PasswordRow(){ row in
                row.title = "原密码"
                row.placeholder = "原来的密码"
                row.add(rule: RuleRequired(msg: "密码不能为空"))
                row.add(rule: RuleMinLength(minLength: 6, msg: "密码至少6位"))
                row.tag = "password"
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
            <<< PasswordRow(){ row in
                row.title = "新密码"
                row.placeholder = "新的密码"
                row.add(rule: RuleRequired(msg: "新密码不能为空"))
                row.add(rule: RuleMinLength(minLength: 6, msg: "新密码至少6位"))
                row.tag = "newPassword"
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
            doPost()
        } else {
            view.makeToast("修改密码格式错误，请检查红色标记", position: .top)
            print("验证失败")
        }
    }
    
    private func doPost() {
        let parameters: Parameters = form.values() as Parameters        
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/changepwd", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    let json = JSON(value)
                    if json["status"].intValue == 1 {
                        self.view.makeToast("修改成功，请重新登录", position: .top)
                        exitUser()                        
                        // 跳转到登录界面
                        let loginSB = UIStoryboard(name: "Login", bundle: nil)
                        let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC")
                        self.navigationController?.pushViewController(loginVC, animated: true)
                    }
                    self.view.makeToast(json["message"].stringValue, position: .top)
                case .failure(let error):
                    self.view.makeToast("修改失败，请稍后再试", position: .top)
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}
