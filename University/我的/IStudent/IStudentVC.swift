//
//  IStudentVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class IStudentVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    let sutdentInfoCell = "sutdentInfoCell"
    
    private var stuInfo: [String] = ["学校", "专业", "学号", "姓名", "性别", "年龄" ,"入学时间"]
    private var stuInfoValue: [String] = []
    
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
        getStudentInfo()
    }
    
    private func initUI() {
        title = "我的学籍"
        setupTableView()
    }
    
    private func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.tableFooterView = UIView()                
        tableView.mj_header = MJRefreshNormalHeader{ [weak self] in
            self?.getStudentInfo()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getStudentInfo() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/student", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.getStudentInfoFrom(student: Student(jsonData: json))
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // 提取出学生信息
    private func getStudentInfoFrom(student: Student?) {
        stuInfoValue.removeAll()
        if let student = student {
            stuInfoValue = [
                student.school,
                student.major,
                student.number,
                student.name,
                student.sex,
                String(student.age),
                student.year
            ]
        }
    }
}

extension IStudentVC: UITableViewDelegate {
    
}

extension IStudentVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stuInfoValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: sutdentInfoCell)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: sutdentInfoCell)
        }
        cell?.textLabel?.text = stuInfo[indexPath.row]
        cell?.detailTextLabel?.text = stuInfoValue[indexPath.row]
        return cell!
    }
}

