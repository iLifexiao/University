//
//  ClubVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ClubVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let clubCell =  "clubCell"
    var clubs: [Club] = []
    
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
        getClub()
    }

    private func initUI() {
        title = "校内社团"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ClubCell", bundle: nil), forCellReuseIdentifier: clubCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getClub()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getClub() {
        Alamofire.request(baseURL + "/api/v1/club/all", headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.clubs.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self?.clubs.append(Club(jsonData: subJson))
                }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

}


extension ClubVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let race = races[indexPath.section]
        let detailRaceVC = DetailRaceVC()
        detailRaceVC.raceInfo = race
        navigationController?.pushViewController(detailRaceVC, animated: true)
         */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension ClubVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return clubs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: clubCell, for: indexPath) as! ClubCell
        let club = clubs[indexPath.section]
        cell.setupModel(club)
        cell.selectionStyle = .none
        return cell
    }
}
