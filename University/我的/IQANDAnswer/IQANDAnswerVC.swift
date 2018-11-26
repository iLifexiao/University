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
import PopMenu

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
        getQuestions()
    }
    
    private func initUI() {
        title = "我的提问"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "arrow_down"), style: .plain, target: self, action: #selector(showMore))
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        
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
        
        tableView.mj_header = MJRefreshNormalHeader{ [weak self] in
            if self?.title == "我的提问" {
                self?.getQuestions()
            }
            
            if self?.title == "我的回答" {
                self?.getAnswers()
            }
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getQuestions() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/questions", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.questions.removeAll()
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
    
    private func getAnswers() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/answers", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.answers.removeAll()
                    // json是数组
                    for (_, subJson):(String, JSON) in json {
                        self.answers.append(Answer(jsonData: subJson))
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @objc func showMore() {
        let manager = PopMenuManager.default
        manager.popMenuDelegate = self
        
        manager.actions = [
            PopMenuDefaultAction(title: "我的提问", image: #imageLiteral(resourceName: "question")),
            PopMenuDefaultAction(title: "我的回答", image: #imageLiteral(resourceName: "comment")),
        ]
        
        // 显示的位置
        manager.present(sourceView: navigationItem.rightBarButtonItem)
    }
    
    @IBAction func askQuestion(_ sender: UIButton) {
        let postQuestionVC = PostQuestionVC()
        navigationController?.pushViewController(postQuestionVC, animated: true)
    }    
}

extension IQANDAnswerVC: PopMenuViewControllerDelegate {
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        switch index {
        case 0:
            getQuestions()
            title = "我的提问"
        case 1:
            getAnswers()
            title = "我的回答"
        default:
            print("NOT Here")
        }
    }
}

extension IQANDAnswerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if title == "我的提问" {
            let question = questions[indexPath.section]
            let AnswerSB = UIStoryboard(name: "Answer", bundle: nil)
            let answerVC = AnswerSB.instantiateViewController(withIdentifier: "AnswerList") as! AnswerVC
            answerVC.questionID = question.id ?? 0
            navigationController?.pushViewController(answerVC, animated: true)
        } else {
            let answer = answers[indexPath.section]
            let detailEssayVC = DetailEssayVC()
            detailEssayVC.answer = answer
            detailEssayVC.type = .answer
            detailEssayVC.id = answer.id ?? 0
            
            // 在没用导航栏的交流页面使用视图管理进行跳转
            if navigationController != nil {
                navigationController?.pushViewController(detailEssayVC, animated: true)
            } else {
                ViewManager.share.secondNVC?.pushViewController(detailEssayVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if title == "我的提问" {
            return 100
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

extension IQANDAnswerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if title == "我的提问" {
            return questions.count
        } else {
            return answers.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if title == "我的提问" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
            cell.setupModel(questions[indexPath.section])
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
            cell.setupModel(answers[indexPath.section])
            cell.selectionStyle = .none
            return cell
        }        
    }
    
    // 侧滑删除功能
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // 编辑
        let editAction = UITableViewRowAction(style: .normal, title: "编辑") { [weak self] (edit, index) in
            guard let self = self else {
                return
            }
            if self.title == "我的提问" {
                let question = self.questions[index.section]
                let postQuestionVC = PostQuestionVC()
                postQuestionVC.question = question
                self.navigationController?.pushViewController(postQuestionVC, animated: true)
            } else {
                let answer = self.answers[index.section]
                // postAnswerVC是连在故事版中的，不能直接通过关联的VC来初始化
                let AnswerSB = UIStoryboard(name: "Answer", bundle: nil)
                let postAnswerVC = AnswerSB.instantiateViewController(withIdentifier: "PostAnswer") as! PostAnswerVC
                postAnswerVC.answer = answer
                self.navigationController?.pushViewController(postAnswerVC, animated: true)
            }
            
        }
        editAction.backgroundColor = #colorLiteral(red: 0.2415607535, green: 0.571031791, blue: 1, alpha: 1)
        
        // 删除
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (delete, index) in
            guard let self = self else {
                return
            }
            if self.title == "我的提问" {
                // 获取ID
                let question = self.questions[index.section]
                let questionID = question.id ?? 0
                
                // 执行逻辑删除操作
                Alamofire.request(baseURL + "/api/v1/question/\(questionID)/logicdel", method: .patch, headers: headers).responseJSON { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        if json["status"].intValue == 1 {
                            self.questions.remove(at: index.section)
                            self.tableView.reloadData()
                        }
                        self.view.makeToast(json["message"].stringValue, position: .top)
                    case .failure(let error):
                        self.view.makeToast("删除失败，稍后再试", position: .top)
                        print(error)
                    }
                }
            } else {
                let answer = self.answers[indexPath.section]
                let answerID = answer.id ?? 0
                
                // 执行逻辑删除操作
                Alamofire.request(baseURL + "/api/v1/answer/\(answerID)/logicdel", method: .patch, headers: headers).responseJSON { [weak self] response in
                    guard let self = self else {
                        return
                    }
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        if json["status"].intValue == 1 {
                            self.answers.remove(at: indexPath.section)
                            self.tableView.reloadData()
                        }
                        self.view.makeToast(json["message"].stringValue, position: .top)
                    case .failure(let error):
                        self.view.makeToast("删除失败，稍后再试", position: .top)
                        print(error)
                    }
                }
            }
            
        }
        return [deleteAction, editAction]
    }
}

//extension IQANDAnswerVC: QuestionCellDelegate {
//    func showMoreInfoAboutQuestion(_ id: String?) {
//        guard let id = id else {
//            return
//        }
//        let AnswerSB = UIStoryboard(name: "Answer", bundle: nil)
//        let postAnswerVC = AnswerSB.instantiateViewController(withIdentifier: "PostAnswer") as! PostAnswerVC
//        postAnswerVC.questionID = Int(id) ?? 0
//        self.present(postAnswerVC, animated: true, completion: nil)
//    }
//}

// MARK: 空视图-代理
extension IQANDAnswerVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("去交流区问问题，或回答看看吧~", position: .top)
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
