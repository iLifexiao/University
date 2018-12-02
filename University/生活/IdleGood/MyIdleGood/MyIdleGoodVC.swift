//
//  MyIdleGoodVC.swift
//  University
//
//  Created by 肖权 on 2018/12/2.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class MyIdleGoodVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var idleGoods: [IdleGood] = []
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        getMyIdleGoods()
    }
    
    private func initUI() {
        title = "我的闲置"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send"), style: .plain, target: self, action: #selector(goPostThing))
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "MyIdleGoodCell", bundle: nil), forCellReuseIdentifier: "MyIdleGoodCell")
        
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
            self?.getMyIdleGoods()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        
        tableView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    
    private func getMyIdleGoods() {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/idlegoods/split?page=1", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.idleGoods.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self.idleGoods.append(IdleGood(jsonData: subJson))
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
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/idlegoods/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
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
                        self.idleGoods.append(IdleGood(jsonData: subJson))
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
        let postIdleGoodVC = PostIdleGoodVC()
        navigationController?.pushViewController(postIdleGoodVC, animated: true)
    }
    
}

extension MyIdleGoodVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let idleGood = idleGoods[indexPath.section]
        let postIdleGoodVC = PostIdleGoodVC()
        postIdleGoodVC.idleGood = idleGood
        navigationController?.pushViewController(postIdleGoodVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension MyIdleGoodVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return idleGoods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyIdleGoodCell", for: indexPath) as! MyIdleGoodCell
        cell.setupModel(idleGoods[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (delete, index) in
            guard let self = self else {
                return
            }
            // 获取ID
            let idleGood = self.idleGoods[indexPath.section]
            let idleGoodID = idleGood.id ?? 0
            
            // 执行逻辑删除操作
            Alamofire.request(baseURL + "/api/v1/idlegood/\(idleGoodID)/logicdel", method: .patch, headers: headers).responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 1 {
                        self.idleGoods.remove(at: indexPath.section)
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
extension MyIdleGoodVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("点击右上角，可以发布闲置物品哦~", position: .top)
    }
}

extension MyIdleGoodVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "emptyBook")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "我还没有发布闲置物品~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}

