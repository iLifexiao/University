//
//  RaceVC.swift
//  University
//
//  Created by 肖权 on 2018/11/12.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class RaceVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let raceCell = "raceCell"
    
    var races: [Race] = []

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
        getRace()
    }
    
    private func initUI() {
        title = "竞赛信息"        
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UINib(nibName: "RaceTableViewCell", bundle: nil), forCellReuseIdentifier: raceCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        // 导致
        tableView.mj_header = MJRefreshNormalHeader{ [weak self] in
            
            // 重新获取
            self?.getRace()
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getRace() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/race/sort", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.races.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.races.append(Race(jsonData: subJson))
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

extension RaceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let race = races[indexPath.section]
        let detailRaceVC = DetailRaceVC()
        detailRaceVC.raceInfo = race
        navigationController?.pushViewController(detailRaceVC, animated: true)        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension RaceVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return races.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: raceCell, for: indexPath) as! RaceTableViewCell
        let race = races[indexPath.section]
        cell.setupModel(race)
        cell.selectionStyle = .none
        return cell
    }
}
