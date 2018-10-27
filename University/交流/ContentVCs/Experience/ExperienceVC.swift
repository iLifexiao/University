//
//  ExperienceVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ExperienceVC: UIViewController {

    private let experienceDefaultCell = "experienceDefault"
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        
    }
}

extension ExperienceVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 1
        default:
            return 10
        }
    }
}

extension ExperienceVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: experienceDefaultCell)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: experienceDefaultCell)
        }
        cell?.imageView?.image = UIImage.init(named: "userHead")
        cell?.textLabel?.text = "iPhone XR 否值得购买？"
        cell?.detailTextLabel?.text = "上一张官网截图，谁说是720P的都来给我瞪大眼睛看清楚是不是720P？ 加一段： 至于有人说我就是给XR洗地黑"
        cell?.selectionStyle = .none
        return cell!
    }
}

