//
//  IMessageVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import PopMenu

class IMessageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
//    private var recMessages: [Message] = []
//    private var sendMessages: [Message] = []
    private var messageDict: [Int: [Message]] = [:]
    private var message: [[Message]] = []
    
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
        getMessages()
    }
    
    private func initUI() {
        title = "我的信箱"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "send"), style: .plain, target: self, action: #selector(sendMessage))
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UINib(nibName: "IMCell", bundle: nil), forCellReuseIdentifier: "IMCell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 空视图代理
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        // 清空-空Cell
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
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/messages", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.message.removeAll()
                    self.messageDict.removeAll()
                    // 将信息以friendID为键，组合添加到字典里
                    for (_, subJson):(String, JSON) in json {
                        let msg = Message(jsonData: subJson)
                        var msgArray = self.messageDict[msg.friendID] ?? [Message]()
                        msgArray.append(msg)
                        self.messageDict[msg.friendID] = msgArray
                    }
                    // 取出 & 排序，让UI显示最后一条
                    for (_, msgs) in self.messageDict {
                        var msgs = msgs
                        msgs.sort { (msg1, msg2) -> Bool in
                            msg1.createdAt! < msg2.createdAt!
                        }
                        self.message.append(msgs)
                    }
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    @objc private func sendMessage() {
        let sendMsgVC = SendMsgVC()
        navigationController?.pushViewController(sendMsgVC, animated: true)
    }
}

// MARK: 信息代理
extension IMessageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messages = message[indexPath.section]
        let lastMsg = messages.last
        let detailMsgVC = DetailMsgVC()
        detailMsgVC.messages = messages
        detailMsgVC.friendID = lastMsg?.friendID ?? 0
        detailMsgVC.nickName = lastMsg?.nickname
        navigationController?.pushViewController(detailMsgVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            return nil
//        case 1:
//            let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
//            tipsHeaderView.setTips(title: "已发信息")
//            return tipsHeaderView
//        default:
//            return nil
//        }
//    }
    
    // HeadView-height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension IMessageVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return message.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 取得最后一条信息
        let lastMsg = message[indexPath.section].last
        let cell = tableView.dequeueReusableCell(withIdentifier: "IMCell", for: indexPath) as! IMCell
        cell.setupModel(lastMsg!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (delete, index) in
            guard let self = self else {
                return
            }
            let lastMsg = self.message[indexPath.section].last
            // 执行删除操作
            // 删除操作的API最好要返回相应信息
            let parameters: Parameters = [
                "userID": GlobalData.sharedInstance.userID,
                "friendID": lastMsg?.friendID ?? 0
            ]
            
            Alamofire.request(baseURL + "/api/v1/message/delall",
                              method: .post,
                              parameters: parameters,
                              headers: headers).responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    // 需要保证网络删除成功后，再删除本地
                    if json["status"].intValue == 1 {
                        self.message.remove(at: index.section)
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


// MARK: 空视图-代理
extension IMessageVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("找个好友聊天吧~", position: .top)
    }
}

extension IMessageVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyMessage")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，还没有信息~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
