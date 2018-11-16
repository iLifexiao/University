//
//  IQANDAnswerVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class IQANDAnswerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var answers: [Answer] = []
    private var questions: [Question] = []
    
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
        getAnswers()
    }
    
    private func initUI() {
        title = "我的问答"
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        
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
            self?.getAnswers()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getAnswers() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/questions", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.questions.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.questions.append(Question(jsonData: subJson))
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

extension IQANDAnswerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension IQANDAnswerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.setupModel(questions[indexPath.section])
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

extension IQANDAnswerVC: QuestionCellDelegate {
    func showMoreInfoAboutQuestion(_ id: String?) {
        view.makeToast(id ?? "0")
    }
}

// MARK: 空视图-代理
extension IQANDAnswerVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("嘿，去交流区问问题吧~")
    }
}

extension IQANDAnswerVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyContent")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，我还没有问答记录~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
