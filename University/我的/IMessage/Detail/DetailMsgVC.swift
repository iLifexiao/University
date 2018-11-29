//
//  DetailMsgVC.swift
//  University
//
//  Created by 肖权 on 2018/11/28.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class DetailMsgVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var msgTextField: UITextField!
    
    var messages: [Message] = []
    var friend: UserInfo?
    var friendID: Int = 0

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
        // 按照时间排序
        messages.sort { (msg1, msg2) -> Bool in
            msg1.createdAt! < msg2.createdAt!
        }
        getMessages()
    }
    
    private func initUI() {
//        title = friend?.nickname
        title = String(friendID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "me"), style: .plain, target: self, action: #selector(showUserInfo))
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MeChatCell", bundle: nil), forCellReuseIdentifier: "MeChatCell")
        tableView.register(UINib(nibName: "YouChatCell", bundle: nil), forCellReuseIdentifier: "YouChatCell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }        
        // 自动适应高度(代理的方法将失效)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
//        // 清空-空Cell
        tableView.tableFooterView = UIView()
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader{ [weak self] in
            // 重新获取
            self?.getMessages()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getMessages() {

    }
    
    @objc func showUserInfo() {
        let detailUserVC = DetailUserVC()
        detailUserVC.userID = friendID
        navigationController?.pushViewController(detailUserVC, animated: true)
    }

    @IBAction func sendMsg(_ sender: UIButton) {
        let content = msgTextField.text?.trimmingCharacters(in: .whitespaces)
        if content == "" {
            view.makeToast("请输入内容", position: .top)
        }
        doPost(content!)
    }
    
    // 发送信息
    private func doPost(_ content: String) {
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "friendID": friendID,
            "fromUserID": GlobalData.sharedInstance.userID,
            "toUserID": friendID,
            "content": content,
            "type": "普通"
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/message/two", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    // 发送成功后，清除输入框的内容
                    self.msgTextField.text = ""
                    self.messages.append(Message(userID: GlobalData.sharedInstance.userID, friendID: self.friendID, fromUserID: GlobalData.sharedInstance.userID, toUserID: self.friendID, content: content))
                    // 显示服务器的提示信息
                    self.view.makeToast(json["message"].stringValue, position: .top)
                    self.tableView.reloadData()
                case .failure(let error):
                    self.view.makeToast("私信发送失败，请稍后再试", position: .top)
                    print(error)
                }
                // 无论请求成功或失败，加载栏都必须消失
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
}

// MARK: 信息代理
extension DetailMsgVC: UITableViewDelegate {

}

extension DetailMsgVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.section]
        // 判断消息的拥有者 和 接收者是否为同一人，是，则表示该消息为用户收到的
        if msg.userID == msg.toUserID {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YouChatCell", for: indexPath) as! YouChatCell
            cell.setupModel(msg)
            cell.selectionStyle = .none
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MeChatCell", for: indexPath) as! MeChatCell
            cell.setupModel(msg)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    // 侧滑删除功能
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let msg = messages[indexPath.row]
        // 执行删除操作
        // 删除操作的API最好要返回相应信息
        Alamofire.request(baseURL + "/api/v1/message/\(msg.id ?? 0)", method: .delete, headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // 需要保证网络删除成功后，再删除本地
                if json["status"].intValue == 1 {
                    self.messages.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
                self.view.makeToast(json["message"].stringValue, position: .top)
            case .failure(let error):
                self.view.makeToast("删除失败，稍后再试", position: .top)
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}
