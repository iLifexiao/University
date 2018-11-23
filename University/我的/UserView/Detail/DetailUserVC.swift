//
//  DetailUserVC.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import PopMenu

class DetailUserVC: UIViewController {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var moreButton: UIButton!
    
    private let userInfoCell = "userInfoCell"
    
    var userInfo: UserInfo?
    var userID: Int = 0 // 0表示进入的是他人的信息中心
    
    private var userInfos = ["自我介绍", "性别", "年龄", "类型", "电话", "邮箱"]
    private var userInfosValue: [String] = []
    
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
        if userID != 0 {
            getUserInfos()
        } else {
            guard let userInfo = userInfo else {
                return
            }
            // 设置ID，从书籍处跳转进来的页面（如果是自己，需要展示个人中心）
            userID = userInfo.userID
            userInfosValue = [
                userInfo.introduce ?? "无",
                userInfo.sex ?? "保密",
                String(userInfo.age ?? 0),
                userInfo.type  ?? "无",
                userInfo.phone  ?? "无",
                userInfo.email ?? "无"
            ]
            self.headImageView.sd_setImage(with: URL(string: baseURL + userInfo.profilephoto), completed: nil)
            self.nameLabel.text = userInfo.nickname
        }
    }
    
    private func initUI() {
        // 仅仅在present时候展示(这里无效？？)
        // 更换为判断是否有导航栏
        if navigationController != nil {
            moreButton.isHidden = true
        }
                
        if userID == GlobalData.sharedInstance.userID {
            title = "个人中心"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(goEditUserInfo))
        } else {
            title = "TA的信息"
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow_down"), style: .plain, target: self, action: #selector(showMore))
        }        
        setupTableView()
    }
    
    private func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.tableFooterView = UIView()
        
        // 因为是复用的View，对于直接传入数据的View不用更新网络数据
        if userID != 0 {
            tableView.mj_header = MJRefreshNormalHeader { [weak self] in
                self?.getUserInfos()
                
                self?.tableView.mj_header.endRefreshing()
                self?.view.makeToast("刷新成功", position: .top)
            }
        }
    }
    
    private func getUserInfos() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(userID)/userinfo", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                self.userInfosValue.removeAll()
                let json = JSON(value)
                self.userInfo = UserInfo(jsonData: json)
                guard let userInfo = self.userInfo else {
                    return
                }
                self.userInfosValue = [
                    userInfo.introduce ?? "无",
                    userInfo.sex ?? "保密",
                    String(userInfo.age ?? 0),
                    userInfo.type  ?? "无",
                    userInfo.phone  ?? "无",
                    userInfo.email ?? "无"
                ]
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
                self.headImageView.sd_setImage(with: URL(string: baseURL + userInfo.profilephoto), completed: nil)
                self.nameLabel.text = userInfo.nickname
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func goEditUserInfo() {
        guard let userInfo = userInfo else {
            view.makeToast("找不到可编辑的用户信息")
            return
        }
        let editUserVC =  EditUserVC()
        editUserVC.userInfo = userInfo
        navigationController?.pushViewController(editUserVC, animated: true)
    }
    
    @objc private func showMore() {
        let manager = PopMenuManager.default
        manager.popMenuDelegate = self
        manager.actions = [
            PopMenuDefaultAction(title: "回关", image: UIImage(named: "focus")),
            PopMenuDefaultAction(title: "私信", image: UIImage(named: "fly")),
        ]
        // 显示的位置
        manager.present(sourceView: navigationItem.rightBarButtonItem)
    }
    
    private func focusBack() {
        guard let userInfo = userInfo else {
            return
        }
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "focusUserID": userInfo.userID
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/focus", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    // 显示服务器的提示信息
                    self.view.makeToast(json["message"].stringValue, position: .top)
                case .failure(let error):
                    self.view.makeToast("关注失败，请稍后再试", position: .top)
                    print(error)
                }
                // 无论请求成功或失败，加载栏都必须消失
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    @IBAction func moreFunc(_ sender: UIButton) {
        // 表示进入自己的详情，功能调整为返回
        if userID == GlobalData.sharedInstance.userID {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // 他人
        let manager = PopMenuManager.default
        manager.popMenuDelegate = self
        
        manager.actions = [
            PopMenuDefaultAction(title: "关注", image: UIImage(named: "focus")),
            PopMenuDefaultAction(title: "私信", image: UIImage(named: "fly")),
            PopMenuDefaultAction(title: "返回", image: UIImage(named: "back")),
        ]
        
        // 显示的位置
        manager.present(sourceView: sender)
    }
    
}

extension DetailUserVC: PopMenuViewControllerDelegate {
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        switch index {
        case 0:
            focusBack()
        case 1:
            guard let userInfo = userInfo else {
                return
            }
            let sendToUserMsgVC = SendToUserMsgVC()
            sendToUserMsgVC.toUserID = userInfo.userID
            navigationController?.pushViewController(sendToUserMsgVC, animated: true)
        case 2:
            dismiss(animated: true, completion: nil)
        default:
            print("错误选项")
        }
    }
}

extension DetailUserVC: UITableViewDelegate {
    
}

extension DetailUserVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userID != 0 {
            return userInfosValue.count
        } else {
            return userInfos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userInfoCell) ?? UITableViewCell(style: .value1, reuseIdentifier: userInfoCell)
        cell.textLabel?.text = userInfos[indexPath.row]
        cell.detailTextLabel?.text = userInfosValue[indexPath.row]
        return cell
    }
}
