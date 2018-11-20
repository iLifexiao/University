//
//  DetailPTJVC.swift
//  University
//
//  Created by 肖权 on 2018/11/20.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DetailPTJVC: UIViewController {

    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var introduceTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    let jobInfoCell = "jobInfoCell"
    
    var job: PartTimeJob?
    var jobInfo = ["工作名", "日结工资", "地点", "联系方式", "截至时间"]
    var jobInfoValue: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    
    private func initData() {
        if let job = job {
            jobInfoValue = [
                job.title,
                String(job.price),
                job.site,
                job.phone,
                job.deadLine
            ]
        } else {
            jobInfoValue = [
                "job.title",
                "job.price",
                "job.site",
                "job.phone",
                "job.deadLine"
            ]
        }
    }
    
    private func initUI() {
        title = "兼职详情"
        setupTableView()
        
        companyLabel.text = job!.company
        introduceTextView.text = job!.introduce
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

extension DetailPTJVC: UITableViewDelegate {
    
}

extension DetailPTJVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: jobInfoCell) ?? UITableViewCell(style: .value1, reuseIdentifier: jobInfoCell)
        cell.textLabel?.text = jobInfo[indexPath.row]
        cell.detailTextLabel?.text = jobInfoValue[indexPath.row]
        return cell
    }
}
