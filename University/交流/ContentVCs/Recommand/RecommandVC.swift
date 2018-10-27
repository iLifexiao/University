//
//  RecommandVC.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class RecommandVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var essays: [EssayModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView() {
        tableView.register(UINib(nibName: "EssayCell", bundle: nil), forCellReuseIdentifier: "EssayCell")
    }
    
    private func initData() {
        let essay = EssayModel(essayID: "1", userHeadImage: UIImage.init(named: "userHead"), userName: "Maclen", postTime: "2018-10-25 22:15", title: "Github上 10 个开源免费且优秀的后台控制面板", type: "资源", content: "Web 开发中几乎的平台都需要一个后台管理，但是从零开发一套后台控制面板并不容易，幸运的是有很多开源免费的后台控制面板可以给开发者使用，那么有哪些优秀的开源免费的控制面板呢？我在 Github 上收集了一些优秀的后台控制面板，并总结得出 Top 10。", readCount: 10, likeCount: 25, commitCount: 2)
        let essay2 = EssayModel(essayID: "2", userHeadImage: UIImage.init(named: "userHead2"), userName: "莫问大叔", postTime: "2018-10-25 22:26", title: "Angelababy：努力没用，你得好看", type: "散文", content: "在以前看来，我觉得这真是个又极端又无聊的问题，在现在看来，我觉得它充满了浓重的现实意味。因新戏而被骂上热搜的Angelababy，就是个典型例子。在剧里，她饰演的是一位投资分析师，拿的是都市精英女白领剧本，演出的是霸道总裁既视感，并且喜怒哀乐，永远都是一个表情：", readCount: 424, likeCount: 25, commitCount: 6)
        let essay3 = EssayModel(essayID: "3", userHeadImage: UIImage.init(named: "userHead3"), userName: "慕课网高清课程", postTime: "2018-10-25 22:29", title: "慕课网实战课程，百度网盘分享！", type: "资源", content: "俗话说“树倒猢狲散”，每一个公司的发展历程都是曲折的，当生意比较火爆的时候，对于公司的发展是好事！可当公司在低迷期的时候，维持公司的正常运转尤为", readCount: 133, likeCount: 2, commitCount: 14)
        let essay4 = EssayModel(essayID: "4", userHeadImage: UIImage.init(named: "userHead4"), userName: "grain先森", postTime: "2018-10-25 22:47", title: "前端-扫码登录实现原理", type: "开发", content: "今天说一说现在比较流行的扫码登录的实现原理。 需求介绍 首先，介绍下什么是扫码登录。现在，大部分同学手机上都装有qq和淘宝，天猫等这一类的软件。", readCount: 13, likeCount: 20, commitCount: 4)
        essays = [essay, essay2, essay3, essay4]
    }

}


extension RecommandVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let essayModel = essays[indexPath.section]
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
 
 extension RecommandVC: UITableViewDataSource {
     // 每个section一篇文章
     func numberOfSections(in tableView: UITableView) -> Int {
         return essays.count
     }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
     }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "EssayCell", for: indexPath) as! EssayCell
         cell.setupData(essays[indexPath.section])
         cell.delegate = self
        
         cell.selectionStyle = .none
         return cell
     }
}

extension RecommandVC: EssayCellDelegate {
     func showMoreInfoAboutEssay(_ id: String?) {
         view.makeToast(id)
     }
     
     func showSameTypeEssay(_ type: String?) {
         view.makeToast(type)
     }
}


