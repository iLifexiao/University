//
//  IExperienceVC.swift
//  University
//
//  Created by 肖权 on 2018/11/16.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class IExperienceVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var experiences: [Experience] = []
    
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
        title = "我的经验"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addExp))
        setupTableView()
    }
    
    private func initData() {
        getExperiences()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "ExperienceCell", bundle: nil), forCellReuseIdentifier: "ExperienceCell")
        
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
            self?.getExperiences()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getExperiences() {
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/experiences", headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.experiences.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self?.experiences.append(Experience(jsonData: subJson))
                }
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func addExp() {
        let postExpVC = PostExpVC()
        navigationController?.pushViewController(postExpVC, animated: true)
    }
}

extension IExperienceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let experience = experiences[indexPath.section]
        let detailEssayVC = DetailEssayVC()
        detailEssayVC.experience = experience
        detailEssayVC.type = .experience
        detailEssayVC.id = experience.id ?? 0
        navigationController?.pushViewController(detailEssayVC, animated: true)        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
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

extension IExperienceVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return experiences.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceCell", for: indexPath) as! ExperienceCell
        cell.setupModel(experiences[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
    
    
    // 侧滑删除功能
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .normal, title: "编辑") { [weak self] (edit, index) in
            guard let self = self else {
                return
            }
            let experience = self.experiences[index.section]
            let postExpVC = PostExpVC()
            postExpVC.experience = experience
            self.navigationController?.pushViewController(postExpVC, animated: true)
        }
        editAction.backgroundColor = #colorLiteral(red: 0.2415607535, green: 0.571031791, blue: 1, alpha: 1)
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (delete, index) in
            guard let self = self else {
                return
            }
            // 获取ID
            let experience = self.experiences[indexPath.section]
            let experienceID = experience.id ?? 0
            
            // 执行逻辑删除操作
            Alamofire.request(baseURL + "/api/v1/experience/\(experienceID)/logicdel", method: .patch, headers: headers).responseJSON { [weak self] response in
                guard let self = self else {
                    return
                }
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    if json["status"].intValue == 1 {
                        self.experiences.remove(at: indexPath.section)
                        self.tableView.reloadData()
                    }
                    self.view.makeToast(json["message"].stringValue, position: .top)
                case .failure(let error):
                    self.view.makeToast("删除失败，稍后再试", position: .top)
                    print(error)
                }
            }
        }
        return [deleteAction, editAction]
    }
}


// MARK: 空视图-代理
extension IExperienceVC: DZNEmptyDataSetDelegate {
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.view.makeToast("点击右上角的加号写写看吧~")
    }
}

extension IExperienceVC: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "emptyContent")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView?) -> NSAttributedString? {
        let text = "啊咧，我还没有写经验~"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24.0), NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.paragraphStyle: paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
