//
//  DetailSchoolStoreVC.swift
//  University
//
//  Created by 肖权 on 2018/11/20.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DetailSchoolStoreVC: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let schoolStoreInfoCell = "schoolStoreInfoCell"
    
    var schoolStore: SchoolStore?
    var schoolStoreInfo = ["营业时间", "地点", "联系方式", "类型", "介绍"]
    var schoolStoreInfoValue: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        if let schoolStore = schoolStore {
            schoolStoreInfoValue = [
                schoolStore.time,
                schoolStore.site,
                schoolStore.phone,
                schoolStore.type,
                schoolStore.introduce
            ]
        } else {
            schoolStoreInfoValue = [
                "schoolStore.time",
                "schoolStore.site",
                "schoolStore.phone",
                "schoolStore.type",
                "schoolStore.introduce"
            ]
        }
    }
    
    private func initUI() {
        title = "商店详情"
        setupTableView()
        
        iconImageView.sd_setImage(with: URL(string: baseURL + schoolStore!.imageURL), completed: nil)
        nameLabel.text = schoolStore!.name
        contentLabel.text = schoolStore!.content
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

extension DetailSchoolStoreVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoValue = schoolStoreInfo[indexPath.row]
        view.makeToast(infoValue, position: .top)
    }
}

extension DetailSchoolStoreVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schoolStoreInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: schoolStoreInfoCell) ?? UITableViewCell(style: .value1, reuseIdentifier: schoolStoreInfoCell)
        cell.textLabel?.text = schoolStoreInfo[indexPath.row]
        cell.detailTextLabel?.text = schoolStoreInfoValue[indexPath.row]
        return cell
    }
}
