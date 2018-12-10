//
//  DetailResourceVC.swift
//  University
//
//  Created by 肖权 on 2018/11/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import SCLAlertView

class DetailResourceVC: UIViewController {
    
    // 懒加载的两种使用方式
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: TopBarHeight, width: ScreenWidth, height: ScreenHeight - TopBarHeight - 50))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ADCell", bundle: nil), forCellReuseIdentifier: "ADCell")
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.tableFooterView = UIView()
        
        return tableView
    }()
    
    lazy var commentView = Bundle.main.loadNibNamed("CommentView", owner: nil, options: nil)![0] as! CommentView
    
    let resourceInfoCell = "resourceInfoCell"
    
    
    var resource: Resource?
    private var type = "resource"
    var id = 0
    
    var userInfo: UserInfo?
    
    private var resourceInfo: [String] = ["资源名称", "类型", "点赞", "推荐者"]
    private var resourceInfoValue: [String] = []
    
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
        readCountIncrease()
        
        guard let resource = resource else {
            return
        }
        resourceInfoValue = [
            resource.name,
            resource.type,
            String(resource.likeCount ?? 0),
        ]
        
        // userID == 0 表示资源为系统推荐
        if resource.userID == 0 {
            resourceInfoValue.append("系统")
        } else {
            resourceInfoValue.append("加载中...")
            getUserInfoBy(id: resource.userID)
        }
    }
    
    private func initUI() {
        title = "资源详情"
        view.backgroundColor = .white
        view.addSubview(tableView)
        commentView.frame = CGRect(x: 0, y: ScreenHeight - TabBarHeight, width: ScreenWidth, height: 50)
        commentView.delegate = self
        view.addSubview(commentView)
        
        guard let resource = resource else {
            return
        }
        commentView.setupCommentViewData(readCount: resource.readCount ?? 0, likeCount: resource.likeCount ?? 0, commentCount: resource.commentCount ?? 0)
    }
    
    private func readCountIncrease() {
        // 设计API为类型标识，可以通过变量来访问不同的API
        Alamofire.request(baseURL + "/api/v1/\(type)/\(id)/read", method: .patch, headers: headers)
    }
    
    private func getUserInfoBy(id: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(id)/userinfo", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.userInfo = UserInfo(jsonData: json)
                self.resourceInfoValue.removeLast()
                self.resourceInfoValue.append(self.userInfo?.nickname ?? "加载失败")
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: 用户交互[返回、写评论、点赞、看评论]
extension DetailResourceVC: CommentViewDelegate {
    func goBackBtnPress() {
        if presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func goCommentBtnPress() {
        let postCommentVC = PostCommentVC()
        postCommentVC.type = "resource"
        postCommentVC.commentID = resource?.id ?? 0
        
        if presentingViewController == nil {
            navigationController?.pushViewController(postCommentVC, animated: true)
        } else {
            self.present(postCommentVC, animated: true, completion: nil)
        }
    }
    
    func likeBtnPress(_ sender: UIButton) {
        if sender.isSelected {
            Alamofire.request(baseURL + "/api/v1/\(type)/\(id)/like", method: .patch, headers: headers)
        } else {
            Alamofire.request(baseURL + "/api/v1/\(type)/\(id)/unlike", method: .patch, headers: headers)
        }
    }
    
    func showComment() {
        let commentVC = CommentVC()
        commentVC.type = "Resource"
        commentVC.commentID = id
        commentVC.authorID = resource?.userID ?? 0
        
        if presentingViewController == nil {
            navigationController?.pushViewController(commentVC, animated: true)
        } else {
            self.present(commentVC, animated: true, completion: nil)
        }
    }
}


extension DetailResourceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            SCLAlertView().showSuccess("推荐理由", subTitle: resource?.introduce ?? "加载错误")
        case 1:
            if indexPath.row == resourceInfo.count - 1 {
                // 点击推荐的用户可以跳转到详细页面
                if let userInfo = userInfo {
                    let detailUserVC = DetailUserVC()
                    detailUserVC.userInfo = userInfo
                    if presentingViewController == nil {
                        navigationController?.pushViewController(detailUserVC, animated: true)
                    } else {
                        self.present(detailUserVC, animated: true, completion: nil)
                    }
                }
            }
        default:
            print("不是这里")
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
}

extension DetailResourceVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return resourceInfoValue.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ADCell", for: indexPath) as! ADCell
            if let resource = resource {
                cell.setupModel(resource)
            }
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: resourceInfoCell) ?? UITableViewCell(style: .value1, reuseIdentifier: resourceInfoCell)
            cell.textLabel?.text = resourceInfo[indexPath.row]
            cell.detailTextLabel?.text = resourceInfoValue[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
}
