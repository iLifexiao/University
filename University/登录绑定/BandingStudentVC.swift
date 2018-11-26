//
//  BandingStudentVC.swift
//  University
//
//  Created by 肖权 on 2018/11/15.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class BandingStudentVC: UIViewController {

    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    private var userID = 0
    
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
        userID = UserDefaults.standard.integer(forKey: userIDKey)
    }
    
    private func initUI() {
        title = "绑定学籍"
    }
    
    private func doBindStudent(number: String, password: String, userID: Int) {
        let parameters: Parameters = [
            "number": number,
            "password": password,
            "userID": userID
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/student/bind", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 1 {                        
                        UserDefaults.standard.set(json["data"]["id"].intValue, forKey: studentIDKey)
                        GlobalData.sharedInstance.studentID = json["data"]["id"].intValue                        
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
    
    @IBAction func bandStudent(_ sender: UIButton) {
        let number = numberTextField.text?.trimmingCharacters(in: .whitespaces)
        let password = pwdTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if number == "" {
            view.makeToast("学号不能为空", position: .top)
            return
        }
        if password == "" {
            view.makeToast("密码不能为空", position: .top)
            return
        }
        
        // 绑定
        doBindStudent(number: number!, password: password!, userID: userID)
    }
    
    @IBAction func exitKeyboard(_ sender: UITapGestureRecognizer) {
        numberTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
}
