//
//  DetailShootPrintVC.swift
//  University
//
//  Created by 肖权 on 2018/11/20.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DetailShootPrintVC: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introduceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    let shootAndPrintInfoCell = "shootAndPrintInfoCell"
    
    var sapServer: ShootAndPrint?
    var sapInfo = ["营业时间", "地点", "联系方式"]
    var sapInfoValue: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        if let sapServer = sapServer {
            sapInfoValue = [
                sapServer.time,
                sapServer.site,
                sapServer.phone
            ]
        } else {
            sapInfoValue = [
                "sapServer.time",
                "sapServer.site",
                "sapServer.phone",
            ]
        }
    }
    
    private func initUI() {
        title = "工作室详情"
        setupTableView()
        
        iconImageView.sd_setImage(with: URL(string: baseURL + sapServer!.imageURL), completed: nil)
        nameLabel.text = sapServer!.name
        introduceLabel.text = sapServer!.introduce
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

extension DetailShootPrintVC: UITableViewDelegate {
    
}

extension DetailShootPrintVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sapInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: shootAndPrintInfoCell) ?? UITableViewCell(style: .value1, reuseIdentifier: shootAndPrintInfoCell)
        cell.textLabel?.text = sapInfo[indexPath.row]
        cell.detailTextLabel?.text = sapInfoValue[indexPath.row]
        return cell
    }
}
