//
//  RecommandVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class RecommandVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var essays: [Essay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
        // Do any additional setup after loading the view.
    }
    
    private func initData() {
        getEssays()
    }
    
    private func initUI() {
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "EssayCell", bundle: nil), forCellReuseIdentifier: "EssayCell")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.getEssays()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getEssays() {
        Alamofire.request(baseURL + "/api/v1/essay/sort", headers: headers).responseJSON { [weak self]  response in
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


extension RecommandVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let essay = essays[indexPath.section]
        let detailEssayVC = DetailEssayVC()
        detailEssayVC.essay = essay
        self.present(detailEssayVC, animated: true, completion: nil)
//        navigationController?.pushViewController(detailEssayVC, animated: true)
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
 
 extension RecommandVC: UITableViewDataSource {
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

extension RecommandVC: EssayCellDelegate {
    func showMoreInfoAboutEssay(_ id: String?) {
        view.makeToast(id)
    }
     
     func showSameTypeEssay(_ type: String?) {
         view.makeToast(type)
     }
}


