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

class PostLostAndFoundVC: FormViewController {

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
                row.title = "上传图片"
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
        } else {
            print("验证失败")
        }
    }
}
