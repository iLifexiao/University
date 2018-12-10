//
//  RegisterVC.swift
//  University
//
//  Created by 肖权 on 2018/11/15.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class RegisterVC: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var checkPwdTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {
        title = "注册"
    }
    
    private func doRegister(account: String, password: String, code: String) {
        let parameters: Parameters = [
            "account": account,
            "password": password,
            "code": code
        ]
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/register", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 1 {
                        self.view.makeToast(json["message"].stringValue, position: .top)
//                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.view.makeToast(json["message"].stringValue, position: .top)
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                case .failure(let error ):
                    print(error)
                }
            }
        }                
    }
    
    @IBAction func registerAccount(_ sender: UIButton) {
        let account = accountTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = pwdTextField.text?.trimmingCharacters(in: .whitespaces)
        let checkPwd = checkPwdTextField.text?.trimmingCharacters(in: .whitespaces)
        let code = codeTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if account == "" {
            view.makeToast("帐号不能为空", position: .top)
            return
        }
        if password == "" {
            view.makeToast("密码不能为空", position: .top)
            return
        }
        if checkPwd == "" {
            view.makeToast("确认密码不能为空", position: .top)
            return
        }
        if code == "" {
            view.makeToast("注册码不能为空", position: .top)
            return
        }        
        if password != checkPwd {
            view.makeToast("两次密码不一致", position: .top)
            return
        }
        if !Regex.checkPhone(account!) {
            view.makeToast("帐号格式错误", position: .top)
            return
        }
        if !Regex.checkPwd(password!) {
            view.makeToast("密码需为6-16位英文、数字、_.*的组合", position: .top)
            return
        }
        
        doRegister(account: account!, password: password!, code: code!)
    }
    
    @IBAction func exitKeyboard(_ sender: UITapGestureRecognizer) {
        accountTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        checkPwdTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
    
}
