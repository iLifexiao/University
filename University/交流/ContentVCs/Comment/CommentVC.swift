//
//  CommentVC.swift
//  University
//
//  Created by 肖权 on 2018/11/21.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class CommentVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // 根据不同的 类型/具体的ID 来获取评论信息
    var type: String = "Essay"
    var commentID = 0
    var comments: [Comment] = []
    var authorID = 0
    private var currentPage = 1
    
    // 在评论过多的时候，复用，这时需要重新设置状态
    var clickStatus: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if presentingViewController == nil {
            tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func initData() {
        getComments(type, commentID: commentID)
    }
    
    private func initUI() {
        title = "评论内容"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: "CommentCell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.tableFooterView = UIView()
                
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getComments(self?.type ?? "Essay", commentID: self?.commentID ?? 0)
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        
        tableView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    
    private func getComments(_ type: String, commentID: Int) {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/comment/type?term=\(type)&id=\(commentID)&page=1", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.comments.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self.comments.append(Comment(jsonData: subJson))
                }
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func loadMore() {
        currentPage += 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/comment/type/split?term=\(type)&id=\(commentID)&page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // 加载完毕
                if json.count == 0 {
                    self.view.makeToast("没有更多了~", position: .top)
                } else {
                    for (_, subJson):(String, JSON) in json {
                        self.comments.append(Comment(jsonData: subJson))
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension CommentVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postCommentVC = PostCommentVC()
//        postCommentVC.sendBackValue = { comment in
//            self.comments.insert(comment, at: 0)
//            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .bottom)
//        }
        postCommentVC.preComment = "回复 " + "\(comments.count - indexPath.row)# ："
        postCommentVC.type = type
        postCommentVC.commentID = commentID
        navigationController?.pushViewController(postCommentVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension CommentVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        cell.setupModel(comments[indexPath.row], authorID: authorID)
        // 评论回复，通过引用楼层
        cell.floorLabel.text = String(comments.count - indexPath.row) + "#"
        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
    
}

// 直接通过更新数据源来完成，如何保证点击的按钮颜色不被改变「用数组保存状态」
extension CommentVC: CommentCellDelegate {
    func commentLike(likeButton: UIButton, likeLabel: UILabel, commentID: String) {
        if GlobalData.sharedInstance.userID == 0 {
            view.makeToast("请先登录", position: .top)
            return
        }
        // 更新评论的点赞数量(考虑：数据源、复用)
        if likeButton.isSelected {
            likeButton.isSelected = false
            
            // 先展示UI，后请求网络
            likeButton.setImage(UIImage(named: "thumup_before"), for: .normal)
            var likeCount = Int(likeLabel.text ?? "0") ?? 0
            likeCount -= 1
            likeLabel.text = String(likeCount)
            
            Alamofire.request(baseURL + "/api/v1/comment/\(commentID)/unlike", method: .patch, headers: headers)
        } else {
            likeButton.isSelected = true
            
            likeButton.setImage(UIImage(named: "thumup_after"), for: .normal)
            var likeCount = Int(likeLabel.text ?? "0") ?? 0
            likeCount += 1
            likeLabel.text = String(likeCount)
            
            Alamofire.request(baseURL + "/api/v1/comment/\(commentID)/like", method: .patch, headers: headers)
        }
    }
}

// MARK: 空视图-代理
extension CommentVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        let postCommentVC = PostCommentVC()
        postCommentVC.type = type
        postCommentVC.commentID = commentID
        navigationController?.pushViewController(postCommentVC, animated: true)
    }
}

extension CommentVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyMessage")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "还没有评论，快来抢沙发~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
