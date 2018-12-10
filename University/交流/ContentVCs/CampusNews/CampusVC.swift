//
//  CampusVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class CampusVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var campusNews: [CampusNews] = []
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
        getCampusNews()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "CampusNewsCell", bundle: nil), forCellReuseIdentifier: "CampusNewsCell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getCampusNews()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
        
        tableView.mj_footer = MJRefreshBackStateFooter { [weak self] in
            self?.loadMore()
            self?.tableView.mj_footer.endRefreshing()
        }
    }
    
    private func getCampusNews() {
        currentPage = 1
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/campusnews/split?page=1", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.campusNews.removeAll()
                // json是数组
                for (_, subJson):(String, JSON) in json {
                    self.campusNews.append(CampusNews(jsonData: subJson))
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
        Alamofire.request(baseURL + "/api/v1/campusnews/split?page=\(currentPage)", headers: headers).responseJSON { [weak self]  response in
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
                        self.campusNews.append(CampusNews(jsonData: subJson))
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

extension CampusVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = campusNews[indexPath.section]
        let detailEssayVC = DetailEssayVC()
        detailEssayVC.campusNews = news
        detailEssayVC.type = .campusNews
        detailEssayVC.id = news.id ?? 0
        ViewManager.share.secondNVC?.pushViewController(detailEssayVC, animated: true)
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

extension CampusVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return campusNews.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CampusNewsCell", for: indexPath) as! CampusNewsCell
        cell.setupModel(campusNews[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}
