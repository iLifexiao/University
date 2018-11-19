//
//  PostBookVC.swift
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

class PostBookVC: FormViewController {

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
        title = "推荐书籍"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "submit"), style: .plain, target: self, action: #selector(submit))
        initForm()
    }
    
    // 表单
    private func initForm() {
        form +++ Section("书籍的基本信息")
            <<< TextRow(){ row in
                row.title = "书名"
                row.placeholder = "书籍名称"
                row.add(rule: RuleRequired(msg: "书名不能为空"))
                row.add(rule: RuleMaxLength(maxLength: 15, msg: "书名需小于15字"))
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
                $0.placeholder = "小说、出版物、辅导..."
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
                $0.title = "作者"
                $0.placeholder = "作者名、笔名"
                $0.add(rule: RuleRequired(msg: "作者名不能为空"))
                $0.add(rule: RuleMaxLength(maxLength: 10, msg: "名字需小于10字"))
                $0.tag = "author"
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
                $0.title = "书籍页数"
                $0.placeholder = "123"
                $0.add(rule: RuleRequired(msg: "书籍页数不能为空"))
                $0.tag = "bookPages"
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
                row.title = "封面图片"
                row.sourceTypes = [.PhotoLibrary, .Camera]
                row.clearAction = .yes(style: UIAlertAction.Style.destructive)
            }
            
            +++ Section("推荐书籍的理由")
            <<< TextAreaRow() {
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
        } else {
            print("验证失败")
        }
    }
        
    private func doPost() {
        // From的tag为post参数的名称
        var parameters: Parameters = form.values() as Parameters
        parameters["userID"] = GlobalData.sharedInstance.userID
        print(parameters)
        /*
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/book", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    print(value)
                    // 发布成功
                    self.view.makeToast("书籍推荐成功", position: .top)
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
 */
    }
}
