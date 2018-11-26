//
//  PostIdleGoodVC.swift
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

class PostIdleGoodVC: FormViewController {
    
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
                doPost()
            default:
                print("错误类型")
                
            }
        }
        get {
            return -1
        }
    }
    
    lazy private var parameters: Parameters = form.values() as Parameters
    let defaultImageURL = "/image/idlegoods/default.png"
    
    private var imagePath: String {
        set {
            guard newValue != "" else {
                MBProgressHUD.hide(for: self.view, animated: true)
                view.makeToast("图片过大(限制<1M)", position: .top)
                return
            }
            parameters["imageURLs"] = [newValue]
            Alamofire.request(baseURL + "/api/v1/idlegood", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
                if let self = self {
                    switch response.result {
                    case .success(let value):
                        print(value)
                        // 发布成功
                        self.view.makeToast("发布成功，返回刷新查看", position: .top)
                    case .failure(let error):
                        self.view.makeToast("发布失败，请稍后再试", position: .top)
                        print(error)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
            
        }
        get {
            return defaultImageURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        
    }
    
    private func initUI() {
        title = "发布闲置物品"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    // 表单
    private func initForm() {
        form +++ Section("在这里填写物品的信息")
            <<< TextRow(){ row in
                row.title = "标题"
                row.placeholder = "简要说明出售的闲置物品"
                row.add(rule: RuleRequired(msg: "标题不能为空"))
                row.add(rule: RuleMaxLength(maxLength: 15, msg: "标题需小于15字"))
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
                $0.placeholder = "手机、衣物、游戏..."
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
            <<< IntRow() {
                $0.title = "原价"
                $0.placeholder = "购买时的价格"
                $0.add(rule: RuleRequired(msg: "原价不能为空"))
                $0.tag = "originalPrice"
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
            <<< IntRow() {
                $0.title = "售价"
                $0.placeholder = "现在出售的价格"
                $0.add(rule: RuleRequired(msg: "售价不能为空"))
                $0.tag = "price"
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
            <<< ImageRow() { row in
                row.title = "上传图片(可选)"
                row.tag = "imageURLs"
                row.placeholderImage = UIImage.fromURL(baseURL + defaultImageURL)
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }
            
            +++ Section("在这里详细说明你物品的亮点")
            <<< TextAreaRow() {
                $0.title = "详细"
                $0.placeholder = "详细说明物品信息和联系方式"
                $0.add(rule: RuleRequired(msg: "描述不能为空"))
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
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        let image = form.values()["imageURLs"] as? UIImage
        if image == nil {
            imagePath = defaultImageURL
        } else {
            uploadImage(image!, type: "idlegoods")
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
                            if json["status"].intValue == 1 {
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
