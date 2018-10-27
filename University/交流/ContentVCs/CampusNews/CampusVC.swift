//
//  CampusVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class CampusVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var campusNews: [CampusNewsModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "CampusNewsCell", bundle: nil), forCellReuseIdentifier: "CampusNewsCell")
    }
    
    private func initData() {
        let news1 = CampusNewsModel(id: "1", title: "你的大学生活费多少？没有花呗还够花吗？", newsImage: UIImage.init(named: "news1"), original: "新东方", readCount: 13, postDate: "10-25")
        let news2 = CampusNewsModel(id: "2", title: "如果穿越回古代，你的专业是啥段位？", newsImage: UIImage.init(named: "news2"), original: "新东方", readCount: 13, postDate: "10-25")
        let news3 = CampusNewsModel(id: "3", title: "考研的5个注意事项，做好任意一点都很关键", newsImage: UIImage.init(named: "news3"), original: "名师有话", readCount: 13, postDate: "10-25")
        campusNews = [news1, news2, news3]
    }
}

extension CampusVC: UITableViewDelegate {
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
        cell.setupData(campusNews[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}
