//
//  LearnVC.swift
//  大学说
//
//  Created by 肖权 on 2018/10/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Toast_Swift
import DNSPageView
import PopMenu

class LearnVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        // 创建DNSPageStyle，设置样式
        let style = DNSPageStyle()
        style.isTitleViewScrollEnabled = true
        style.isTitleScaleEnabled = true                
        style.titleViewHeight = 50
        
        // 设置标题内容
        let titles = ["推荐", "关注", "校园", "阅读", "问答", "经验", "资源"]
        
        // 创建每一页对应的controller，使用xib可直接使用，不像UIView文件
        let recomnandVC = RecommandVC()
        let foucsVC = FocusVC()
        let campusVC = CampusVC()
        let readingVC = ReadingVC()
        let questionVC = QuestionVC()
        let experienceVC = ExperienceVC()
        let resourcesVC = ResourcesVC()
        let childViewControllers: [UIViewController] = [recomnandVC, foucsVC, campusVC, readingVC, questionVC, experienceVC, resourcesVC]
        
        // 创建对应的DNSPageView，并设置它的frame
        // titleView和contentView会连在一起
        let pageView = DNSPageView(frame: CGRect(x: 0, y: TopBarHeight, width: ScreenWidth, height: ScreenHeight - TopBarHeight - 80), style: style, titles: titles, childViewControllers: childViewControllers)
        view.addSubview(pageView)
    }    
    
    @IBAction func searchEssayPress(_ sender: UIBarButtonItem) {
        view.makeToast("搜索")
    }
    
    @IBAction func learnFuns(_ sender: UIBarButtonItem) {
        let manager = PopMenuManager.default
        manager.popMenuDelegate = self
        manager.actions = [
            PopMenuDefaultAction(title: "写文章", image: UIImage(named: "writeEssay")),
            PopMenuDefaultAction(title: "找朋友", image: UIImage(named: "addFriend"))
        ]
        manager.present(sourceView: sender)
    }
    
}

// Mark: PopMenuViewControllerDelegate
extension LearnVC: PopMenuViewControllerDelegate {
    
    func popMenuDidSelectItem(_ popMenuViewController: PopMenuViewController, at index: Int) {
        view.makeToast("Show \(index)")
    }
    
}
