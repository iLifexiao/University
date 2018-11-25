//
//  PostLostAndFoundVC.swift
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
import WXImageCompress

class PostLostAndFoundVC: FormViewController {
    
    
    lazy private var parameters: Parameters = form.values() as Parameters
    let defaultImageURL = "/image/lostandfound/default.png"
   
    // 用于上传图片完成后，才进行post信息
    private var imagePath: String {
        set {
            guard newValue != "" else {
                MBProgressHUD.hide(for: self.view, animated: true)
                view.makeToast("图片过大(限制<1M)", position: .top)
                return
            }
            parameters["imageURL"] = [newValue]
            Alamofire.request(baseURL + "/api/v1/lostandfound", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
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
            return "/image/lostandfound/default.png"
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
        title = "发布失物"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    // 表单
    private func initForm() {
        form +++ Section("在这里填写物品的信息")
            <<< TextRow(){ row in
                row.title = "标题"
                row.placeholder = "简要说明丢失的物品"
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
            <<< DateRow() {
                $0.title = "时间"
                $0.value = Date()
                $0.tag = "time"
            }
            <<< TextRow() {
                $0.title = "地点"
                $0.placeholder = "丢失的地点"
                $0.add(rule: RuleRequired(msg: "地点不能为空"))
                $0.add(rule: RuleMaxLength(maxLength: 10, msg: "地点需小于10字"))
                $0.tag = "site"
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
                row.tag = "imageURL"
                row.placeholderImage = UIImage.fromURL(baseURL + defaultImageURL)
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }
            <<< TextAreaRow() {
                $0.title = "详细"
                $0.placeholder = "详细说明丢失的物品和联系方式"
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
            doPost()
        } else {
            print("验证失败")
        }
    }
    
    private func doPost() {
        parameters["userID"] = GlobalData.sharedInstance.userID
        
        // 将Date -> String格式
        let time = form.values()["time"] as? Date
        parameters["time"] = time?.toFormat("YYYY-MM-dd") ?? Date().toFormat("YYYY-MM-dd")
        
        // 提取图片
        // 图库上传的是图片的assert地址，并非真实URL
        let image = form.values()["imageURL"] as? UIImage
        // 如果没有选择图片，使用默认图片
        // 否则上传图片，并返回地址
        if image == nil {
            imagePath = defaultImageURL
        } else {
            uploadImage(image!, type: "lostandfound")
        }
    }
    
    private func uploadImage(_ image: UIImage, type: String) {
        // 将上传类型编码为Data（才能通过data传输）
        let typeData = type.data(using: .utf8)
        guard typeData != nil else {
            view.makeToast("参数编码失败，稍后再试", position: .top)
            return
        }
        // 压缩图片
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
        
        // 上传图片
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
