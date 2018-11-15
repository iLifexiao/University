//
//  ForgetPwdVC.swift
//  University
//
//  Created by 肖权 on 2018/11/15.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ForgetPwdVC: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var newPwdTextField: UITextField!
    @IBOutlet weak var checkNewPwdTextField: UITextField!
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
        title = "重置密码"
    }
    
    private func doChangePwd(account: String, password: String, code: String) {        
        let parameters: Parameters = [
            "account": account,
            "password": password,
            "code": code
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/lostpwd", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 0 {
                        self.view.makeToast(json["message"].stringValue, position: .top)
//                        self.navigationController?.popViewController(animated: true)                        
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
    
    @IBAction func changePwd(_ sender: UIButton) {
        let account = accountTextField.text?.trimmingCharacters(in: .whitespaces)
        let newPassword = newPwdTextField.text?.trimmingCharacters(in: .whitespaces)
        let checknewPassword = checkNewPwdTextField.text?.trimmingCharacters(in: .whitespaces)
        let code = codeTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if account == "" {
            view.makeToast("帐号不能为空", position: .top)
            return
        }
        if newPassword == "" {
            view.makeToast("密码不能为空", position: .top)
            return
        }
        if checknewPassword == "" {
            view.makeToast("确认密码不能为空", position: .top)
            return
        }
        if code == "" {
            view.makeToast("修改码不能为空，联系管理员获取", position: .top)
            return
        }
        if newPassword != checknewPassword {
            view.makeToast("两次密码不一致", position: .top)
            return
        }
        
        doChangePwd(account: account!, password: newPassword!, code: code!)
    }
            
    @IBAction func exitKeyboard(_ sender: UITapGestureRecognizer) {
        accountTextField.resignFirstResponder()
        newPwdTextField.resignFirstResponder()
        checkNewPwdTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
}
