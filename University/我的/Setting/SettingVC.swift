//
//  SettingVC.swift
//  University
//
//  Created by 肖权 on 2018/11/25.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let settingCell = "settingCell"
    
    private struct SettingModel {
        let icon: UIImage?
        let name: String
    }
    
    private lazy var settings: [SettingModel] = [
        SettingModel(icon: #imageLiteral(resourceName: "pwd"), name: "修改密码"),
        SettingModel(icon: #imageLiteral(resourceName: "quit"), name: "退出登录"),
        SettingModel(icon: #imageLiteral(resourceName: "about"), name: "关于软件")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {
        title = "软件设置"
        setupTableView()
    }
    
    private func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.tableFooterView = UIView()
    }
}

extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let changePwdVC = ChangePwdVC()
            navigationController?.pushViewController(changePwdVC, animated: true)
        case 1:
            let ctrl = UIAlertController(title: "温馨提示", message: "确定退出登录？\n将自动返回登录界面", preferredStyle: .alert)
            let sureAction = UIAlertAction(title: "确定", style: .destructive) { action in
                // 退出登录的时候，清除用户数据
                UserDefaults.standard.set(0, forKey: userIDKey)
                UserDefaults.standard.set(0, forKey: studentIDKey)
                // 默认用户信息
                UserDefaults.standard.set("用户未登录", forKey: userNameKey)
                UserDefaults.standard.set("/image/defalut.png", forKey: userHeadKey)
                GlobalData.sharedInstance.userID = 0
                GlobalData.sharedInstance.studentID = 0
                GlobalData.sharedInstance.userName = "用户未登录"
                GlobalData.sharedInstance.userHeadImage = "/image/default.png"
                // 跳转到登录界面
                let loginSB = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC")
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel) { action in}
            ctrl.addAction(sureAction)
            ctrl.addAction(cancelAction)
            present(ctrl, animated: true, completion: nil)
        case 2:
            let aboutSoftVC = AboutSoftVC()
            navigationController?.pushViewController(aboutSoftVC, animated: true)
        default:
            print("Not here")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension SettingVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: settingCell) ?? UITableViewCell(style: .default, reuseIdentifier: settingCell)
        let setting = settings[indexPath.row]
        cell.imageView?.image = setting.icon
        cell.textLabel?.text = setting.name
        cell.selectionStyle = .none
        return cell
    }
}
