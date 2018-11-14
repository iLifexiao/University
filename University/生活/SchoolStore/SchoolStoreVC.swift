//
//  SchoolStoreVC.swift
//  University
//
//  Created by 肖权 on 2018/11/14.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class SchoolStoreVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var stores: [SchoolStore] = []
    
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
        getSchoolStores()
    }
    
    private func initUI() {
        title = "校园周边"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "SchoolStoreCell", bundle: nil), forCellReuseIdentifier: "SchoolStoreCell")
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getSchoolStores()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getSchoolStores() {
        Alamofire.request(baseURL + "/api/v1/schoolstore/all", headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.stores.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self?.stores.append(SchoolStore(jsonData: subJson))
                }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


extension SchoolStoreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 101.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension SchoolStoreVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return stores.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolStoreCell", for: indexPath) as! SchoolStoreCell
        cell.setupModel(stores[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}
