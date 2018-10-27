//
//  FocusVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class FocusVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var focusEssays: [EssayModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "EssayCell", bundle: nil), forCellReuseIdentifier: "EssayCell")
    }
    
    private func initData() {
        let essay = EssayModel(essayID: "2", userHeadImage: UIImage.init(named: "userHead2"), userName: "莫问大叔", postTime: "2018-10-25 22:26", title: "Angelababy：努力没用，你得好看", type: "散文", content: "在以前看来，我觉得这真是个又极端又无聊的问题，在现在看来，我觉得它充满了浓重的现实意味。因新戏而被骂上热搜的Angelababy，就是个典型例子。在剧里，她饰演的是一位投资分析师，拿的是都市精英女白领剧本，演出的是霸道总裁既视感，并且喜怒哀乐，永远都是一个表情：", readCount: 424, likeCount: 25, commitCount: 6)
        let essay2 = EssayModel(essayID: "4", userHeadImage: UIImage.init(named: "userHead4"), userName: "grain先森", postTime: "2018-10-25 22:47", title: "前端-扫码登录实现原理", type: "开发", content: "今天说一说现在比较流行的扫码登录的实现原理。 需求介绍 首先，介绍下什么是扫码登录。现在，大部分同学手机上都装有qq和淘宝，天猫等这一类的软件。", readCount: 13, likeCount: 20, commitCount: 4)
        focusEssays = [essay, essay2]
    }
}

extension FocusVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let essayModel = focusEssays[indexPath.section]
        let essayTitle = essayModel.title
        view.makeToast(essayTitle)
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

extension FocusVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return focusEssays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EssayCell", for: indexPath) as! EssayCell
        cell.setupData(focusEssays[indexPath.section])
        cell.delegate = self
        
        cell.selectionStyle = .none
        return cell
    }
}

extension FocusVC: EssayCellDelegate {
    func showMoreInfoAboutEssay(_ id: String?) {
        view.makeToast(id)
    }
    
    func showSameTypeEssay(_ type: String?) {
        view.makeToast(type)
    }
}
