//
//  DetailRaceVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DetailRaceVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let infoCell = "infoCell"
    let detailCell = "detailCell"
    
    var raceInfo: Race?
    var detailCellHeight: CGFloat = 0.0
    
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
        guard raceInfo != nil else {
            return
        }
        let textMaxSize = CGSize(width: ScreenWidth, height: CGFloat(MAXFLOAT))
        detailCellHeight = textSize(text: raceInfo!.content, font: UIFont.systemFont(ofSize: 17), maxSize: textMaxSize).height
    }
    
    private func initUI() {
        title = "竞赛情况"        
        setupTableView()
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UINib(nibName: "RaceInfoCell", bundle: nil), forCellReuseIdentifier: infoCell)
        tableView.register(UINib(nibName: "RaceDetailCell", bundle: nil), forCellReuseIdentifier: detailCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension DetailRaceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 160
        default:
            return detailCellHeight
        }
    }
    
    // HeadView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
            tipsHeaderView.setTips(title: "比赛介绍")
            return tipsHeaderView
        default:
            return nil
        }
    }
    
    // HeadView-height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
}

extension DetailRaceVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCell, for: indexPath) as! RaceInfoCell
            if let raceInfo = raceInfo {
                cell.setupModel(raceInfo)
            }
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCell, for: indexPath) as! RaceDetailCell
            if let raceInfo = raceInfo {
                cell.setupModel(raceInfo)
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    
}

