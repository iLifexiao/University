//
//  PropertyManagerVC.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class PropertyManagerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let propertyManagerCell = "addressCell"
    var managers: [PropertyManager] = []
    private var currentPage = 1
    
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
        getPropertyManager()
    }
    
    private func initUI() {
        title = "物业报修"
        setupTableView()
    }
    
    private func setupTableView() {
//        tableView.register(UINib(nibName: "AddressListCell", bundle: nil), forCellReuseIdentifier: addressCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getPropertyManager()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        
        tableView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    
    private func getPropertyManager() {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/propertymanager/split?page=1", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.managers.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.managers.append(PropertyManager(jsonData: subJson))
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func loadMore() {
        currentPage += 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/propertymanager/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
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
                        self.managers.append(PropertyManager(jsonData: subJson))
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


extension PropertyManagerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension PropertyManagerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return managers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: propertyManagerCell)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: propertyManagerCell)
        }
        let manager = managers[indexPath.section]
        cell?.imageView?.sd_setImage(with: URL(string: baseURL + manager.imageURL), completed: nil)
        cell?.textLabel?.text = manager.name + "（\(manager.ability)）"
        cell?.detailTextLabel?.text = "电话：" + manager.phone
        cell?.selectionStyle = .none
        return cell!
    }
}
