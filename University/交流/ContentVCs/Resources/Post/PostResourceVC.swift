//
//  PostResourceVC.swift
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

class PostResourceVC: FormViewController {
    
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
                if resource == nil {
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

    lazy private var parameters: Parameters = form.values() as Parameters
    let defaultImageURL = "/image/resource/default.png"
    
    var resource: Resource?
    
    // 记录是否更新了图片，节省上传图片的资源
    private var beforeImage: UIImage?
    
    private var imagePath: String {
        set {
            guard newValue != "" else {
                MBProgressHUD.hide(for: self.view, animated: true)
                view.makeToast("图片过大(限制<1M)", position: .top)
                return
            }
            parameters["imageURL"] = newValue
            if resource == nil {
                Alamofire.request(baseURL + "/api/v1/resource", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
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
            } else {
                Alamofire.request(baseURL + "/api/v1/resource/\(resource!.id ?? 0)", method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
                    if let self = self {
                        switch response.result {
                        case .success(let value):
                            print(value)
                            // 发布成功
                            self.view.makeToast("更新成功，返回刷新查看", position: .top)
                        case .failure(let error):
                            self.view.makeToast("更新失败，请稍后再试", position: .top)
                            print(error)
                        }
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    private func initData() {
        beforeImage = UIImage.fromURL(baseURL + (resource?.imageURL ?? defaultImageURL))
    }
    
    private func initUI() {
        if resource == nil {
            title = "推荐资源"
        } else {
            title = "更新资源"
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    // 表单
    private func initForm() {
        form +++ Section("资源的基本信息")
            <<< TextRow(){ row in
                row.title = "名称"
                row.value = resource?.name
                row.placeholder = "资源的名称，或描述"
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
                $0.title = "类型"
                $0.value = resource?.type
                $0.placeholder = "工具、音乐、编程..."
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
            <<< ImageRow() { row in
                row.title = "封面图片(可选)"
                row.tag = "imageURL"
                row.value = beforeImage                
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }
            
            +++ Section("推荐资源的理由")
            <<< TextAreaRow() {
                $0.value = resource?.introduce
                $0.placeholder = "写出你独具慧眼的理由吧~"
                $0.add(rule: RuleRequired(msg: "理由不能为空"))
                $0.tag = "introduce"
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
            self.view.makeToast("资源格式错误，请检查红色标记", position: .top)
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
        
        // 修改，判断是否更改了图片
        let image = form.values()["imageURL"] as? UIImage
        if image == beforeImage {
            imagePath = defaultImageURL
        } else {
            uploadImage(image!, type: "resource")
        }
    }
    
    private func doPatch() {
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        let image = form.values()["imageURL"] as? UIImage
        if image == beforeImage {
            imagePath = resource!.imageURL
        } else {
            uploadImage(image!, type: "resource")
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
                        if let data = response.data {
                            let json = JSON(data)
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
