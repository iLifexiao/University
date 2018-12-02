//
//  MyLostVC.swift
//  University
//
//  Created by 肖权 on 2018/12/2.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class MyLostVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var losts: [LostAndFound] = []
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        getMyLost()
    }
    
    private func initUI() {
        title = "我的失物"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send"), style: .plain, target: self, action: #selector(goPostThing))
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MyLostCell", bundle: nil), forCellReuseIdentifier: "MyLostCell")
        
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
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getMyLost()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        
        tableView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.tableView.mj_footer.endRefreshing()
        }
    }

    private func getMyLost() {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/lostandfounds/split?page=1", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.losts.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self.losts.append(LostAndFound(jsonData: subJson))
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func loadMore() {
        currentPage += 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/lostandfounds/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if json.count == 0 {
                    self.view.makeToast("没有更多了~", position: .top)
                } else {
                    for (_, subJson):(String, JSON) in json {
                        self.losts.append(LostAndFound(jsonData: subJson))
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc private func goPostThing() {
        let postLostAndFoundVC = PostLostAndFoundVC()
        navigationController?.pushViewController(postLostAndFoundVC, animated: true)
    }

}

extension MyLostVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lost = losts[indexPath.section]
        let postLostAndFoundVC = PostLostAndFoundVC()
        postLostAndFoundVC.lost = lost
        navigationController?.pushViewController(postLostAndFoundVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension MyLostVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return losts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyLostCell", for: indexPath) as! MyLostCell
        cell.setupModel(losts[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (delete, index) in
            guard let self = self else {
                return
            }
            // 获取ID
            let lost = self.losts[indexPath.section]
            let lostID = lost.id ?? 0
            
            // 执行逻辑删除操作
            Alamofire.request(baseURL + "/api/v1/lostandfound/\(lostID)/logicdel", method: .patch, headers: headers).responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 1 {
                        self.losts.remove(at: indexPath.section)
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
extension MyLostVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("点击右上角，可以发布失物招领哦~", position: .top)
    }
}

extension MyLostVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "emptyBook")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "我还没有丢失物品~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

