//
//  LoginVC.swift
//  University
//
//  Created by 肖权 on 2018/11/15.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class LoginVC: UIViewController {
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    
    // 保存的用户数据
    private var account: String?
    private var password: String?
    private var isAutoLogin = true
    
    // 登录完成后，获取用户绑定的学生(传递用户ID过来)
    private var loginSucceed: Int {
        set {
            Alamofire.request(baseURL + "/api/v1/user/\(newValue)/student", headers: headers).responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["error"].boolValue {
                        print(json["reason"].stringValue)
                    } else {
                        GlobalData.sharedInstance.studentID = json["id"].intValue
                        UserDefaults.standard.set(json["id"].intValue, forKey: studentIDKey)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        get {
            return 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initData() {
        isAutoLogin = UserDefaults.standard.bool(forKey: autoLoginKey)
        account = UserDefaults.standard.value(forKey: accountKey) as? String
        password = UserDefaults.standard.value(forKey: passwordKey) as? String
    }
    
    private func initUI() {
        title = "登录"
        if isAutoLogin {
            checkButton.setImage(UIImage(named: "checkTrue"), for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "check"), for: .normal)
        }
        accountTextField.text = account
        pwdTextField.text = password
    }
    
    private func doLogin(account: String, password: String) {
        let parameters: Parameters = [
            "account": account,
            "password": password
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    // 登录成功
                    if json["status"].intValue == 0 {
                        // 并获取学生ID
                        self.loginSucceed = json["data"]["userID"].intValue
                        // 记录登录用户的ID(更新全局变量)
                        UserDefaults.standard.set(json["data"]["userID"].intValue, forKey: userIDKey)
                        GlobalData.sharedInstance.userID = json["data"]["userID"].intValue
                        
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.view.makeToast(json["message"].stringValue, position: .top)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func userLogin(_ sender: UIButton) {
        // 用户输入检查
        let account = accountTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = pwdTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if account == "" {
            view.makeToast("帐号不能为空", position: .top)
            return
        }
        if password == "" {
            view.makeToast("密码不能为空", position: .top)
            return
        }
        
        // 如果设置了自动登录，记录用户输入的帐号密码，否则清空
        if isAutoLogin {
            UserDefaults.standard.set(account, forKey: accountKey)
            UserDefaults.standard.set(password, forKey: passwordKey)
        } else {
            UserDefaults.standard.set(nil, forKey: accountKey)
            UserDefaults.standard.set(nil, forKey: passwordKey)
        }
        
        // 登录
        doLogin(account: account!, password: password!)
    }
    
    // 自动登录，需要用户点击登录按钮后，才能进行保存帐号和密码
    @IBAction func autoLoginCheck(_ sender: UIButton) {
        if isAutoLogin {
            isAutoLogin = false
            sender.setImage(UIImage(named: "check"), for: .normal)
            UserDefaults.standard.set(false, forKey: autoLoginKey)
        } else {
            isAutoLogin = true
            sender.setImage(UIImage(named: "checkTrue"), for: .normal)
            UserDefaults.standard.set(true, forKey: autoLoginKey)
        }
    }
    
    @IBAction func exitKeyboard(_ sender: UITapGestureRecognizer) {
        accountTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
    // 返回调用的函数
    @IBAction func unwindSegueRegisterVC(_ unwindSegue: UIStoryboardSegue) {
        // 这里设置的是segue的ID
        if unwindSegue.identifier == "unwindSegueRegister" {
            // 返回的时候，谁拥有segue谁就是source
            if let svc = unwindSegue.source as? RegisterVC {
                // 这里就可以进行一些操作
                accountTextField.text  = svc.accountTextField.text
                pwdTextField.text = svc.pwdTextField.text
            }
        }
    }
    
    @IBAction func unwindSegueForgetPwdVC(_ unwindSegue: UIStoryboardSegue) {        
        if unwindSegue.identifier == "unwindSegueForget" {
            if let svc = unwindSegue.source as? ForgetPwdVC {
                accountTextField.text  = svc.accountTextField.text
                pwdTextField.text = svc.newPwdTextField.text
            }
        }
    }
    
}
