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
    var nickName: String?
    var friendID: Int = 0
    
    var hasUnreadMessage = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollToBottom()
    }
    
    private func initData() {
        // 当存在未读私信时
        if hasUnreadMessage {
            readAll()
        }
    }

    private func initUI() {
        title = nickName
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "me2"), style: .plain, target: self, action: #selector(showUserInfo))
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
        
        // 清空-空Cell
        tableView.tableFooterView = UIView()
        
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getMessages()
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func readAll() {
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "friendID": friendID
        ]                
        Alamofire.request(baseURL + "/api/v1/message/readall", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
    }
    
    private func getMessages() {
        let parameters: Parameters = [
            "userID": GlobalData.sharedInstance.userID,
            "friendID": friendID
        ]
        
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/message/showim", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.messages.removeAll()
                    for (_, subJson): (String, JSON) in json {
                        self.messages.append(Message(jsonData: subJson))
                    }
                    // 按照时间排序
                    self.messages.sort { (msg1, msg2) -> Bool in
                        msg1.createdAt! < msg2.createdAt!
                    }
                    self.tableView.reloadData()
                    self.scrollToBottom()
                case .failure(let error):
                    self.view.makeToast("聊天记录加载失败，请稍后再试", position: .top)
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    private func scrollToBottom() {
        let indexPath = tableView.numberOfSections
        if indexPath > 0 {
            let row = tableView.numberOfRows(inSection: indexPath - 1)
            tableView.scrollToRow(at: IndexPath(row: row - 1, section: indexPath - 1), at: .bottom, animated: false)
        }
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
                    var msg = Message(userID: GlobalData.sharedInstance.userID,
                                      friendID: self.friendID,
                                      fromUserID: GlobalData.sharedInstance.userID,
                                      toUserID: self.friendID, content: content)
                    msg.createdAt = Date().timeIntervalSince1970                    
                    self.messages.append(msg)
                    // 显示服务器的提示信息
                    self.view.makeToast(json["message"].stringValue, position: .top)
                    self.tableView.reloadData()
                    self.scrollToBottom()
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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (delete, index) in
            guard let self = self else {
                return
            }
            let msg = self.messages[indexPath.section]
            // 执行删除操作
            // 删除操作的API最好要返回相应信息
            Alamofire.request(baseURL + "/api/v1/message/\(msg.id ?? 0)/logicdel", method: .patch, headers: headers).responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    // 需要保证网络删除成功后，再删除本地
                    if json["status"].intValue == 1 {
                        self.messages.remove(at: indexPath.section)
                        self.tableView.reloadData()
                    }
                    self.view.makeToast(json["message"].stringValue, position: .top)
                case .failure(let error):
                    self.view.makeToast("删除失败，稍后再试", position: .top)
                    print(error)
                }
            }
        }
        return [deleteAction]
    }
}
