//
//  DetailBookVC.swift
//  University
//
//  Created by 肖权 on 2018/11/22.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import SCLAlertView

class DetailBookVC: UIViewController {

    // 懒加载的两种使用方式
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: TopBarHeight, width: ScreenWidth, height: ScreenHeight - TopBarHeight))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "ReadingCell", bundle: nil), forCellReuseIdentifier: "ReadingCell")
        
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
    
    let bookInfoCell = "bookInfoCell"
//    let bookCommentCell = "bookCommentCell"
    
    
    var book: Book?
    private var type = "book"
    var id = 0
    
    var userInfo: UserInfo?
    
    private var bookInfo: [String] = ["书籍名称", "类型", "作者", "页数", "推荐者"]
    private var bookInfoValue: [String] = []
    
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
        
        guard let book = book else {
            return
        }
        bookInfoValue = [
            book.name,
            book.type,
            book.author,
            String(book.bookPages)
        ]
        
        // userID == 0 表示书籍为系统推荐
        if book.userID == 0 {
            bookInfoValue.append("系统")
        } else {
            bookInfoValue.append("加载中...")
            getUserInfoBy(id: book.userID)
        }
    }
    
    private func initUI() {
        title = "书籍详情"
        view.backgroundColor = .white
        view.addSubview(tableView)
        commentView.frame = CGRect(x: 0, y: tableView.frame.height, width: ScreenWidth, height: 50)
        commentView.delegate = self
        view.addSubview(commentView)
        
        guard let book = book else {
            return
        }
        commentView.setupCommentViewData(readCount: book.readedCount ?? 0, likeCount: book.likeCount ?? 0, commentCount: book.commentCount ?? 0)
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
                self.bookInfoValue.removeLast()
                self.bookInfoValue.append(self.userInfo?.nickname ?? "加载失败")
                
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: 用户交互[返回、写评论、点赞、看评论]
extension DetailBookVC: CommentViewDelegate {
    func goBackBtnPress() {
        if presentingViewController == nil {
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func goCommentBtnPress() {
        let postCommentVC = PostCommentVC()
        postCommentVC.type = "Book"
        postCommentVC.commentID = book?.id ?? 0
        
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
        commentVC.type = "Book"
        commentVC.commentID = id
        
        if presentingViewController == nil {
            navigationController?.pushViewController(commentVC, animated: true)
        } else {
            self.present(commentVC, animated: true, completion: nil)
        }
    }
}


extension DetailBookVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            SCLAlertView().showSuccess("推荐理由", subTitle: book?.introduce ?? "加载错误")
        case 1:
            if indexPath.row == 4 {
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
            return 200
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension DetailBookVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return bookInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingCell
            if let book = book {
                cell.setupModel(book)
            }
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: bookInfoCell) ?? UITableViewCell(style: .value1, reuseIdentifier: bookInfoCell)
            cell.textLabel?.text = bookInfo[indexPath.row]
            cell.detailTextLabel?.text = bookInfoValue[indexPath.row]
            cell.selectionStyle = .none
            return cell
        }
    }
}
