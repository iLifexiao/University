//
//  ResourcesVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ResourcesVC: UIViewController {
    
    var adModels: [ADModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "ADCell", bundle: nil), forCellReuseIdentifier: "ADCell")
    }
    
    private func initData() {
        let adDicts = [["icon": "github", "title": "GitHub",
                        "content": "We’re supporting a community where more than 31 million* people learn, share, and work together to build software.",
                        "type": "工具"],
                       ["icon": "netlesson", "title": "网易公开课",
                        "content": "作为中国最大最全的课程视频平台，拥有来自国内外顶尖学府的海量名师名课，覆盖文学艺术、历史哲学、经济社会、物理化学、心理管理、计算机技术等二十多个专业领域",
                        "type": "教育"],
                       ["icon": "ted", "title": "TED",
                        "content": "TED官方安卓软件可为您展现世界上各界人士的演讲：教育精英，科技天才，医疗技师，商业领袖，以及音乐传奇。 ",
                        "type": "教育"],
                       ["icon": "swift", "title": "Swift",
                        "content": "工业级别的编程语言，类型安全、面向接口、类型推断的全平台开发语言",
                        "type": "编程"],
                       ["icon": "MOOC", "title": "中国大学MOOC",
                        "content": "中国大学MOOC(慕课)是由网易公司与教育部爱课程网携手推出的在线教育平台，汇集中国名牌大校的MOOC(慕课)课程。在这里，每一个有意愿提升自己的人都可以免费获得优质的高等教育资源。",
                        "type": "教育"]
            
        ]
        for dict in adDicts {
            let adModel = ADModel(icon: UIImage.init(named: dict["icon"]!), title: dict["title"], content: dict["content"], type: dict["type"])
            adModels.append(adModel)
        }
    }
}

extension ResourcesVC: UITableViewDelegate {
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

extension ResourcesVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return adModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ADCell", for: indexPath) as! ADCell
        cell.setupData(adModels[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}
