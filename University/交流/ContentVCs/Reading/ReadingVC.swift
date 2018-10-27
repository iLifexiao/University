//
//  ReadingVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class ReadingVC: UIViewController {
    
    private var books: [ReadingModel] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
    }
    
    private func setupTableView() {
        tableView.register(UINib.init(nibName: "ReadingCell", bundle: nil), forCellReuseIdentifier: "ReadingCell")
    }
    
    private func initData() {
        let book1 = ReadingModel(id: "1", icon: UIImage.init(named: "book1"), name: "狐小月与羊大森 2", author: "月生", readCount: 234, bookPages: 119, detail: "狐小月和羊大森，是一对跨物种小夫妻，他们和寻常人一样，深陷在欢乐而琐碎的生活里。九个轻松有趣的日常小故事，来自一个爱好文学和插画的工科女")
        let book2 = ReadingModel(id: "2", icon: UIImage.init(named: "book2"), name: "在等的人", author: "第九杯茶", readCount: 23, bookPages: 50, detail: "律师肖客在回家途中于剑门关下捡了一个独自旅行的女孩，从此开始了与这女孩的无数次相遇。再见之时，他以为她就是那种随便的女孩，所以带她去了宾馆，于是她还了他一巴掌。这一巴掌让他们成了仇人，而后又在法庭上碰面的二人，分别坐在了原告和第三人的席位上。故事还在继续，人生也在不断刷新，他们又一次命运般相遇时，她成了他合伙人的女朋友。时光就这般流逝，而他们似乎总在冥冥中相遇。一个律师与一个网络作家的爱情故事，到底谁才是谁人生路上在等的那个人呢？")
        let book3 = ReadingModel(id: "3", icon: UIImage.init(named: "book3"), name: "天空之海", author: "猫爪君", readCount: 34, bookPages: 19, detail: "少年小天因一次致命经历患上了妄想症，他笃定自己是一条鱼，大海将是他的最终归宿。在被送入帕斯卡精神康复医院后，他遇见了“飞鸟男孩”乔羽，两个少年的生命轨迹也因此发生改变。然而与此同时，小天又被宿命般地卷入到一场与生物灾难对抗的战争中，被迫与乔羽分别。十二年后，当两人再次重逢时，灾难卷土重来，命运的牢笼也在此刻无声降下")
        books = [book1, book2, book3]
    }
}

extension ReadingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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

extension ReadingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath) as! ReadingCell
        cell.setupData(books[indexPath.section])
        cell.selectionStyle = .none
        return cell
    }
}

