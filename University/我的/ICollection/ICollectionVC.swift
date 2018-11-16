//
//  ICollectionVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ICollectionVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let collectionCell = "collectionCell"
    private var collections: [Collection] = []
    
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
        getCollections()
    }
    
    private func initUI() {
        title = "我的收藏"
        setupTableView()
    }
    
    private func setupTableView() {
//        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        
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
            self?.getCollections()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getCollections() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/collections", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.collections.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.collections.append(Collection(jsonData: subJson))
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

extension ICollectionVC: UITableViewDelegate {

}

extension ICollectionVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: collectionCell)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: collectionCell)
        }
        let collection = collections[indexPath.section]
        cell?.textLabel?.text = collection.type
        cell?.detailTextLabel?.text = String(collection.collectionID)
        cell?.selectionStyle = .none
        return cell!
    }
}


// MARK: 空视图-代理
extension ICollectionVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        view.makeToast("嘿，去交流区看看吧~")
    }
}

extension ICollectionVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyCollection")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，收藏消失了~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
