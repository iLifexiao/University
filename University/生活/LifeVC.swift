//
//  LifeVC.swift
//  大学说
//
//  Created by 肖权 on 2018/10/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import FSPagerView
import Toast_Swift

class LifeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bannerImages: [URL] = []
    var news: [String] = []
    var lifeServers: [LifeFuncModel] = []
    var campusAround: [LifeFuncModel] = []
    
    let bannerCell = "bannerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupTableView()
    }
    
    private func initData() {
        // Banner
        for index in 0...4 {
            if let url = URL(string: "https://picsum.photos/375/200/?image=\(200+index)") {
                bannerImages.append(url)
            }
        }
        
        // News
        news = ["5#207 打印低至19.9", "丰富晚餐仅需19.9", "今日优惠请查收"]
        
        // lifeServers
        let lifeFunc1 = LifeFuncModel(icon: UIImage.init(named: "secondHand"), title: "校园闲鱼")
        let lifeFunc2 = LifeFuncModel(icon: UIImage.init(named: "water"), title: "水电查询")
        let lifeFunc3 = LifeFuncModel(icon: UIImage.init(named: "photos"), title: "摄影打印")
        let lifeFunc4 = LifeFuncModel(icon: UIImage.init(named: "proporty"), title: "物业报修")
        lifeServers = [lifeFunc1, lifeFunc2, lifeFunc3, lifeFunc4]
        
        // campusAround
        let campusFunc1 = LifeFuncModel(icon: UIImage.init(named: "store"), title: "好店推荐")
        let campusFunc2 = LifeFuncModel(icon: UIImage.init(named: "partJob"), title: "兼职信息")
        campusAround = [campusFunc1, campusFunc2]
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: bannerCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}

extension LifeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        view.makeToast("section: \(indexPath.section), row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1, 2 :
            return 60
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        default:
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
    
    // HeadView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
            tipsHeaderView.setTips(title: "生活服务", icon: UIImage(named: "life_server"))
            return tipsHeaderView
        case 2:
            let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
            tipsHeaderView.setTips(title: "校园周边", icon: UIImage(named: "around"))
            return tipsHeaderView
        default:
            return nil
        }
    }
}

extension LifeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return lifeServers.count
        case 2:
            return campusAround.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: bannerCell, for: indexPath)
            if cell.contentView.subviews.count == 0 {
                // Banner视图
                let pagerView = FSPagerView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250))
                pagerView.automaticSlidingInterval = 3.0
                pagerView.isInfinite = true
                // 显示的样式下，需要调整itemSize才能显示完全
                pagerView.transformer = FSPagerViewTransformer(type: .linear)
//                pagerView.itemSize = CGSize(width: ScreenWidth - 40, height: 200)
                pagerView.dataSource = self
                pagerView.delegate = self
                pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BannerCell")
                cell.contentView.addSubview(pagerView)
                
                // 通知栏
                let headlineView = Bundle.main.loadNibNamed("HeadlineView", owner: nil, options: nil)?[0] as! HeadlineView
                headlineView.frame = CGRect.init(x: 0, y: 250, width: ScreenWidth, height: 50)
                headlineView.setIcon(UIImage.init(named: "gift"))
                headlineView.setTitle("活动")
                headlineView.delegate = self
                headlineView.setNews(news)
                cell.contentView.addSubview(headlineView)
            }
            cell.accessoryType = .none
            cell.selectionStyle = .none
            return cell
        case 1:
            // 生活服务
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            let model = lifeServers[indexPath.row]
            cell.imageView?.image = model.icon
            cell.textLabel?.text = model.title
            cell.selectionStyle = .none
            return cell
        case 2:
            // 校园周边
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            let model = campusAround[indexPath.row]
            cell.imageView?.image = model.icon
            cell.textLabel?.text = model.title
            cell.selectionStyle = .none
            return cell
        default:
            // 默认空白的
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.accessoryType = .none
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: FSPagerViewDelegate
extension LifeVC: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        view.makeToast("你选中了：\(index)")
    }
}

// MARK: FSPagerViewDataSource
extension LifeVC: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerImages.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerCell", at: index)
        cell.imageView?.sd_setImage(with: bannerImages[index], completed: nil)
        cell.textLabel?.text = String(index)
        return cell
    }
}

// MARK: NotificationDelegate
extension LifeVC: HeadlineViewDelegate {
    func headlineView(_ headlineView: HeadlineView, didSelectItemAt index: Int) {
        view.makeToast("news: \(index)")
    }
}
