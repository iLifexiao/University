//
//  IEssayVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class IEssayVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var essays: [Essay] = []
    
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
        getEssays()
    }
    
    private func initUI() {
        title = "我的文章"
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "EssayCell", bundle: nil), forCellReuseIdentifier: "EssayCell")
        
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
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getEssays()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getEssays() {
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/essays", headers: headers).responseJSON { [weak self]  response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.essays.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self?.essays.append(Essay(jsonData: subJson))
                }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


extension IEssayVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let essay = essays[indexPath.section]
        let essayTitle = essay.title
        view.makeToast(essayTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        default:
            return 20
        }
    }
}

extension IEssayVC: UITableViewDataSource {
    // 每个section一篇文章
    func numberOfSections(in tableView: UITableView) -> Int {
        return essays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EssayCell", for: indexPath) as! EssayCell
        cell.setupModel(essays[indexPath.section])
        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: 文章-MORE-点击代理
extension IEssayVC: EssayCellDelegate {
    func showMoreInfoAboutEssay(_ id: String?) {
        view.makeToast(id)
    }
    
    func showSameTypeEssay(_ type: String?) {
        view.makeToast(type)
    }
}

// MARK: 空视图-代理
extension IEssayVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("去 交流区 写一篇文章试试吧~")
    }
}

extension IEssayVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyEssay")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，还没有文章~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
