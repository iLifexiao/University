//
//  QuestionVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class QuestionVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var questions: [Question] = []
    private var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    private func initUI() {
        setupTableView()
    }
    
    private func initData() {
        getQuestions()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
            
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getQuestions()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        
        tableView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    
    private func getQuestions() {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/question/split?page=1", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.questions.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self.questions.append(Question(jsonData: subJson))
                }
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    private func loadMore() {
        currentPage += 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/question/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // 加载完毕
                if json.count == 0 {
                    self.view.makeToast("没有更多了~", position: .top)
                } else {
                    for (_, subJson):(String, JSON) in json {
                        self.questions.append(Question(jsonData: subJson))
                    }
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}

extension QuestionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let question = questions[indexPath.section]
        // 采用storyboard组织业务逻辑
        let AnswerSB = UIStoryboard(name: "Answer", bundle: nil)
        let answerVC = AnswerSB.instantiateViewController(withIdentifier: "AnswerList") as! AnswerVC
        answerVC.questionID = question.id ?? 0
        ViewManager.share.secondNVC?.pushViewController(answerVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }
}

extension QuestionVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.setupModel(questions[indexPath.section])
//        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
}

//extension QuestionVC: QuestionCellDelegate {
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
