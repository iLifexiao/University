//
//  ExaminationVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ExaminationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let examinationCell = "examinationCell"
    
    var examinations: [Examination] = []
    
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
        getExamination()
    }
    
    private func initUI() {
        title = "考试安排"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "ExaminationCell", bundle: nil), forCellReuseIdentifier: examinationCell)
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            // 重新获取
            self?.getExamination()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        })
    }
    
    private func getExamination() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/examination/sort", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.examinations.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.examinations.append(Examination(jsonData: subJson))
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

extension ExaminationVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
         let academic = academics[indexPath.section]
         let detailInfoVC = DetailInfoVC()
         detailInfoVC.academic = academic
         navigationController?.pushViewController(detailInfoVC, animated: true)
         */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension ExaminationVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return examinations.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: examinationCell, for: indexPath) as! ExaminationCell
        let examination = examinations[indexPath.section]
        cell.setupModel(examination)
        cell.selectionStyle = .none
        return cell
    }
}
