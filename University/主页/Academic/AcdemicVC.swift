//
//  AcdemicVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class AcdemicVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let academicCell = "academicCell"
    
    var academics: [Academic] = []
    
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
        getAcademic()
    }
    
    private func initUI() {
        title = "教务通知"
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
//        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: academicCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader{ [weak self] in
            // 重新获取
            self?.getAcademic()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getAcademic() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/academic/sort", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.academics.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.academics.append(Academic(jsonData: subJson))
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

extension AcdemicVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let academic = academics[indexPath.section]
        let detailInfoVC = DetailInfoVC()
        detailInfoVC.academic = academic
        navigationController?.pushViewController(detailInfoVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension AcdemicVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return academics.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: academicCell)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: academicCell)
        }
        let academic = academics[indexPath.section]
        cell?.textLabel?.text = academic.title
        cell?.detailTextLabel?.text = academic.type + " | " + academic.time
        cell?.selectionStyle = .none
        return cell!
    }
}
