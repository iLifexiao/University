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

class IMessageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var messages: [Message] = []
    
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
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
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
                    self.messages.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.messages.append(Message(jsonData: subJson))
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: 信息代理
extension IMessageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension IMessageVC: UITableViewDataSource {    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        cell.setupModel(messages[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}


// MARK: 空视图-代理
extension IMessageVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("找个好友聊天吧~")
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
