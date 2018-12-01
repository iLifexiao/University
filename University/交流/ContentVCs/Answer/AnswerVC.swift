//
//  AnswerVC.swift
//  University
//
//  Created by 肖权 on 2018/11/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class AnswerVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var questionID = 0
    private var answers: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {
        title = "回答列表"
        setupTableView()
    }
    
    private func initData() {
        getAnswers()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        tableView.tableFooterView = UIView()
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getAnswers()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getAnswers() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/question/\(questionID)/answer", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPostAnswerVC",
            let postAnswerVC = segue.destination as? PostAnswerVC {
                postAnswerVC.questionID = questionID
            }
    }
}

extension AnswerVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // 最后一个不显示
        if section == answers.count - 1 {
            return 0
        }
        return 10
    }
    
}

extension AnswerVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        cell.setupModel(answers[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: 空视图-代理
extension AnswerVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("知道答案，快来抢答吧~", position: .top)
    }
}

extension AnswerVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyMessage")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，这个问题还没有解答~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
//
//extension UIViewController {
//    var contents: UIViewController {
//        if let navcon = self as? UINavigationController {
//            return navcon.visibleViewController ?? self
//        } else {
//            return self
//        }
//    }
//}
