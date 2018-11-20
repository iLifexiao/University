//
//  ILessonGradeVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class ILessonGradeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let lessonCell = "lessonCell"
    let infoCell = "infoCell"
    
    var lessonGrades: [LessonGrade] = []
    var lessonInfo = ["通过", "失败", "获得学分", "平均绩点"]
    var lessonInfoValue: [String] = []
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "analyse"), style: .plain, target: self, action: #selector(analyseGrade))
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UINib(nibName: "LessonGradeCell", bundle: nil), forCellReuseIdentifier: lessonCell)
        
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
                    self.getGradeInfo(self.lessonGrades)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func getGradeInfo(_ lessonGrades: [LessonGrade]) {
        guard lessonGrades.count != 0 else {
            return
        }
        var passCount = 0
        var failCount = 0
        var allCredit: Float = 0.0
        var getPoint: Float = 0.0
        
        lessonInfoValue.removeAll()
        
        for grade in lessonGrades {
            allCredit += grade.credit
            getPoint += grade.credit * grade.gradePoint
            if grade.grade >= 60 {
                passCount += 1
            } else {
                failCount += 1
            }
        }
        // 平均绩点(学分 * 课程绩点 / 总学分)
        
        lessonInfoValue = [
            String(passCount),
            String(failCount),
            String(format: "%.2f", allCredit),
            String(format: "%.2f", getPoint / allCredit)
        ]
    }
    
    @objc func analyseGrade() {
        let analyseGradeVC = AnalyseGradeVC()
        navigationController?.pushViewController(analyseGradeVC, animated: true)
    }
}

extension ILessonGradeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let lessonGrade = lessonGrades[indexPath.row]
            let toast = String(format: "课程绩点:%.2f", lessonGrade.gradePoint)
            view.makeToast(toast, position: .center)
        default:
            print("Not Here")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70.0
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // HeadView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
            tipsHeaderView.setTips(title: "成绩统计")
            return tipsHeaderView
        default:
            return nil
        }
    }
    
    // HeadView-height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
}

extension ILessonGradeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return lessonGrades.count
        default:
            return lessonInfoValue.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: lessonCell, for: indexPath) as! LessonGradeCell
            let lessonGrade = lessonGrades[indexPath.row]
            cell.setupModel(lessonGrade)
            cell.selectionStyle = .none
            return cell
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: infoCell)
            if cell == nil {
                cell = UITableViewCell(style: .value1, reuseIdentifier: infoCell)
            }
            cell?.textLabel?.text = lessonInfo[indexPath.row]
            cell?.detailTextLabel?.text = lessonInfoValue[indexPath.row]
            cell?.selectionStyle = .none
            return cell!
        }

    }
}

// MARK: 空视图-代理
extension ILessonGradeVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("联系管理员，或重新试试看~", position: .top)
    }
}

extension ILessonGradeVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyGrade")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，成绩消失了~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
