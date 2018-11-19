//
//  ClubDetailVC.swift
//  University
//
//  Created by 肖权 on 2018/11/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ClubDetailVC: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let clubInfoCell = "clubInfoCell"
    
    var club: Club?
    var clubInfo = ["成立时间", "人数", "级别", "类型"]
    var clubInfoValue: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        if let club = club {
            clubInfoValue = [
                club.time,
                String(club.numbers),
                club.rank,
                club.type
            ]
        } else {
            clubInfoValue = [
                "club.time",
                "club.numbers",
                "club.rank",
                "club.type"
            ]
        }
    }
    
    private func initUI() {
        guard let club = club else {
            title = "加载失败了"
            return
        }
        title = "社团详情"
        setupTableView()
        
        iconImageView.sd_setImage(with: URL(string: baseURL + club.imageURL), completed: nil)
        nameLabel.text = club.name
        introduceLabel.text = club.introduce
    }
    
    private func setupTableView() {
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }        
        tableView.tableFooterView = UIView()
    }
}

extension ClubDetailVC: UITableViewDelegate {
    
}

extension ClubDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clubInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: clubInfoCell)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: clubInfoCell)
        }
        cell?.textLabel?.text = clubInfo[indexPath.row]
        cell?.detailTextLabel?.text = clubInfoValue[indexPath.row]
        return cell!
    }
}

