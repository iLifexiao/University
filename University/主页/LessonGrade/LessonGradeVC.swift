//
//  LessonGradeVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class LessonGradeVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let lessonCell = "lessonCell"
    
    var lessonGrades: [LessonGrade] = []
    
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
        getLessonGrade()
    }
    
    private func initUI() {
        title = "成绩单"
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
                tableView.register(UINib(nibName: "LessonGradeCell", bundle: nil), forCellReuseIdentifier: lessonCell)
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader{ [weak self] in
            // 重新获取
            self?.getLessonGrade()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getLessonGrade() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/student/grade", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.lessonGrades.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.lessonGrades.append(LessonGrade(jsonData: subJson))
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

extension LessonGradeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let academic = academics[indexPath.section]
        let detailInfoVC = DetailInfoVC()
        detailInfoVC.academic = academic
        navigationController?.pushViewController(detailInfoVC, animated: true)
        */
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension LessonGradeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return lessonGrades.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: lessonCell, for: indexPath) as! LessonGradeCell
        let lessonGrade = lessonGrades[indexPath.section]
        cell.setupModel(lessonGrade)
        cell.selectionStyle = .none
        return cell
    }
}
