//
//  AddressListVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class AddressListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let addressCell = "addressCell"
    var addressList: [AddressList] = []
    
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
        getAddressList()
    }
    
    private func initUI() {
        title = "校内通讯录"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "AddressListCell", bundle: nil), forCellReuseIdentifier: addressCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getAddressList()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getAddressList() {
        Alamofire.request(baseURL + "/api/v1/addresslist/all", headers: headers).responseJSON { [weak self]  response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.addressList.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self?.addressList.append(AddressList(jsonData: subJson))
                }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


extension AddressListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension AddressListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: addressCell, for: indexPath) as! AddressListCell
        cell.setupModel(addressList[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}
