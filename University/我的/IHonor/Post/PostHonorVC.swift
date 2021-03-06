//
//  PostHonorVC.swift
//  University
//
//  Created by 肖权 on 2018/11/20.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka
import ImageRow
import Toast_Swift

class PostHonorVC: FormViewController {
    
    private var userStatus: Int {
        set {
            // 表示用户状态正常
            switch newValue {
            case 0:
                if GlobalData.sharedInstance.userID == 0 {
                    view.makeToast("请先登录", position: .top)
                } else {
                    exitUser()
                    view.makeToast("帐号被封禁，请联系管理员", position: .top)
                }
            case 1:
                if honor == nil {
                    doPost()
                } else {
                    doPatch()
                }
            default:
                print("未知错误")
            }
        }
        get {
            // 需要设置和服务器返回的状态码不一致的数字，赋值的时候，回返回这个数值并重新赋值
            return -1
        }
    }
    
    var honor: Honor?

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
        if honor == nil {
            title = "新增荣誉"
        } else {
            title = "更新荣誉"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    private func initForm() {
        form +++ Section("荣誉的基本信息")
            <<< TextRow(){ row in
                row.title = "名称"
                row.value = honor?.name
                row.placeholder = "荣誉的名称"
                row.add(rule: RuleRequired(msg: "名称不能为空"))
                row.add(rule: RuleMaxLength(maxLength: 15, msg: "名称需小于15字"))
                row.tag = "name"
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
                $0.title = "等级"
                $0.value = honor?.rank
                $0.placeholder = "四/六级、一等奖、奖学金..."
                $0.add(rule: RuleRequired(msg: "等级不能为空"))
                $0.add(rule: RuleMaxLength(maxLength: 10, msg: "等级需小于10字"))
                $0.tag = "rank"
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
            <<< DateRow() {
                $0.title = "时间"
                $0.value = honor?.time.toDate()?.date ?? Date()
                $0.tag = "time"
                }        
    }
    
    @objc private func submit() {
        let errors = form.validate()
        if errors.count == 0 {
            print("验证成功")
            checkUserStatus()
        } else {
            self.view.makeToast("荣誉格式错误，请检查红色标记", position: .top)
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
        
        // 将Date -> String格式
        let time = form.values()["time"] as? Date
        parameters["time"] = time?.toFormat("YYYY-MM-dd") ?? Date().toFormat("YYYY-MM-dd")
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/honor", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    // 发布成功
                    self.view.makeToast("荣誉添加成功，返回刷新查看", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    self.view.makeToast("荣誉添加失败，请稍后再试", position: .top)
                    print(error)
                }
            }
        }
    }
    
    private func doPatch() {
        var parameters: Parameters = form.values() as Parameters
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        // 将Date -> String格式
        let time = form.values()["time"] as? Date
        parameters["time"] = time?.toFormat("YYYY-MM-dd") ?? Date().toFormat("YYYY-MM-dd")
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/honor/\(honor!.id ?? 0)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    self.view.makeToast("荣誉更新成功，返回刷新查看", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    self.view.makeToast("荣誉更新失败，请稍后再试", position: .top)
                    print(error)
                }
            }
        }
    }
}
