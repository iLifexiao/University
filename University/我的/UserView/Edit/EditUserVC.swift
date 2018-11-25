//
//  EditUserVC.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Eureka
import ImageRow
import Toast_Swift

class EditUserVC: FormViewController {
    
    lazy private var parameters: Parameters = form.values() as Parameters
    var defaultImageURL: String?
    
    private var imagePath: String {
        set {
            guard newValue != "" else {
                MBProgressHUD.hide(for: self.view, animated: true)
                view.makeToast("图片过大(限制<1M)", position: .top)
                return
            }
            parameters["profilephoto"] = newValue
            Alamofire.request(baseURL + "/api/v1/userinfo/\(userInfo?.id ?? 0)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
                if let self = self {
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        let userInfo = UserInfo(jsonData: json)
                        // 发布成功
                        // 1. 更新本地文件
                        UserDefaults.standard.set("用户未登录", forKey: userInfo.nickname)
                        UserDefaults.standard.set("/image/defalut.png", forKey: userInfo.profilephoto)
                        
                        // 2. 更新全局变量
                        GlobalData.sharedInstance.userName = userInfo.nickname
                        GlobalData.sharedInstance.userHeadImage = userInfo.profilephoto
                        
                        self.view.makeToast("更新成功", position: .top)
                    case .failure(let error):
                        self.view.makeToast("更新失败，请稍后再试", position: .top)
                        print(error)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            
        }
        get {
            return defaultImageURL ?? ""
        }
    }
    
    var userInfo: UserInfo?
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
        defaultImageURL = userInfo?.profilephoto ?? "/image/head/default.png"
    }
    
    private func initUI() {
        title = "编辑资料"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    private func initForm() {
        guard let userInfo = userInfo else {
            return
        }
        form +++ Section("你的头像")
            <<< ImageRow() { row in
                row.title = "头像"
                row.placeholderImage = UIImage.fromURL(baseURL + defaultImageURL!)
                row.tag = "profilephoto"
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
                }.cellUpdate { cell, row in
                    cell.accessoryView?.layer.cornerRadius = 17
                    cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
                }
            
            +++ Section("基本信息")
            <<< TextRow() { row in
                row.title = "昵称"
                row.placeholder = "你的网名"
                row.value = userInfo.nickname
                row.add(rule: RuleRequired(msg: "昵称不能为空"))
                row.add(rule: RuleMaxLength(maxLength: 15, msg: "昵称不能超过15字"))
                row.tag = "nickname"
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
            <<< ActionSheetRow<String>() {
                $0.title = "性别"
                $0.selectorTitle = "选择你的性别（可选）"
                $0.options = ["男","女","保密"]
                $0.value = userInfo.sex ?? "保密"
                $0.tag = "sex"
            }
            <<< IntRow() {
                $0.title = "年龄"
                $0.placeholder = "你的年龄（可选）"
                $0.value = userInfo.age ?? 18
                $0.tag = "age"
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
            <<< PhoneRow() {
                $0.title = "电话"
                $0.placeholder = "你的联系方式（可选）"
                $0.value = userInfo.phone ?? "17777777777"
                $0.tag = "phone"
                }
            <<< EmailRow() {
                $0.title = "邮箱"
                $0.placeholder = "你的邮箱地址（可选）"
                $0.value = userInfo.email ?? "17777777777@163.com"
                $0.tag = "email"
                }
            
            +++ Section("自我介绍")
            <<< TextAreaRow() {
                $0.placeholder = "介绍一下你自己吧~（可选）"
                $0.value = userInfo.introduce ?? "这个人很cool，还没有自我介绍"
                $0.tag = "introduce"
                }
    }
    
    @objc private func submit() {
        let errors = form.validate()
        if errors.count == 0 {
            print("验证成功")
            doPost()
        } else {
            self.view.makeToast("个人信息格式错误，请检查红色标记", position: .top)
            print("验证失败")
        }
    }
    
    private func doPost() {
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        let image = parameters["profilephoto"] as? UIImage
        if image == nil {
            imagePath = defaultImageURL!
        } else {
            uploadImage(image!, type: "head")
        }
    }
    
    private func uploadImage(_ image: UIImage, type: String) {
        let typeData = type.data(using: .utf8)
        guard typeData != nil else {
            view.makeToast("参数编码失败，稍后再试", position: .top)
            return
        }
        
        let comPressImage = image.wxCompress(type: .session)
        var imageData = comPressImage.jpegData(compressionQuality: 1.0)
        guard imageData != nil else {
            view.makeToast("图片处理失败，稍后再试", position: .top)
            return
        }
        // 将图片转换为Data(1048576)，需要在稍微压缩一点质量（4K图片）
        if imageData!.count > 1_048_574 {
            imageData = comPressImage.jpegData(compressionQuality: 0.9)!
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageData!, withName: "image", fileName: "type.jpeg" ,mimeType: "image/jpeg")
                multipartFormData.append(typeData!, withName: "type")
        },
            to: baseURL + "/api/v1/upload/image",
            headers: headers,
            encodingCompletion: { [weak self] encodingResult in
                guard let self = self else {
                    return
                }
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        // 获取响应数据
                        if let data = response.data {
                            let json = JSON(data)
                            // 图片可能过大(最大只能是1M)
                            if json["status"].intValue == 0 {
                                print(json["message"].stringValue)
                                self.imagePath = json["message"].stringValue
                            } else {
                                self.view.makeToast(json["message"].stringValue, position: .top)
                                MBProgressHUD.hide(for: self.view, animated: true)
                            }
                        }
                    }
                case .failure(let encodingError):
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.view.makeToast("图片上传失败，稍后再试", position: .top)
                    print(encodingError)
                }
            }
        )
        
    }
}
