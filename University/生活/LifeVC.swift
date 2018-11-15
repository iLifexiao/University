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
import Alamofire
import SwiftyJSON

class LifeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var pagerView: FSPagerView?
    var headlineView: HeadlineView?
    
//    var news: [String] = []
    var lifeServers: [LifeFuncModel] = []
    var campusAround: [LifeFuncModel] = []
    
    let bannerCell = "bannerCell"
    
    // 网络数据
    var adBanners: [ADBanner] = []
    var notifications: [Notification] = []
    var news: [String] {
        get {
            var titles: [String] = []
            for notifi in notifications {
                titles.append(notifi.title)
            }
            return titles
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func initData() {
        // Banner、ad
        getADBanner()
        getNotifications()
        
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
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getADBanner()
            self?.getNotifications()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func getADBanner() {
        Alamofire.request(baseURL + "/api/v1/adbanner/all/life", headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self?.adBanners.removeAll()
                // json是数组
                for (_,subJson):(String, JSON) in json {
                    self?.adBanners.append(ADBanner(jsonData: subJson))
                }
                self?.pagerView?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getNotifications() {
        Alamofire.request(baseURL + "/api/v1/notification/all/life", headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // json是数组
                self?.notifications.removeAll()
                for (_,subJson):(String, JSON) in json {
                    self?.notifications.append(Notification(jsonData: subJson))
                }
                self?.headlineView?.setNews(self?.news ?? [])
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension LifeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                let idleGoodVC = IdleGoodVC()
                navigationController?.pushViewController(idleGoodVC, animated: true)
            case 1:
                let utilityBillVC = UtilityBillVC()
                navigationController?.pushViewController(utilityBillVC, animated: true)
            case 2:
                let shootAndPrintVC = ShootAndPrintVC()
                navigationController?.pushViewController(shootAndPrintVC, animated: true)
            case 3:
                let propertyManagerVC = PropertyManagerVC()
                navigationController?.pushViewController(propertyManagerVC, animated: true)
            default:
                print("生活服务-选择了错误的行")
            }
        case 2:
            switch indexPath.row {
            case 0:
                let schoolStoreVC = SchoolStoreVC()
                navigationController?.pushViewController(schoolStoreVC, animated: true)
            case 1:
                let partTimeJobVC = PartTimeJobVC()
                navigationController?.pushViewController(partTimeJobVC, animated: true)
            default:
                print("校园周边-选择了错误的行")
            }
        default:
            print("selctSectionOne")
        }
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
                pagerView = FSPagerView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250))
                pagerView?.automaticSlidingInterval = 3.0
                pagerView?.isInfinite = true
                // 显示的样式下，需要调整itemSize才能显示完全
                pagerView?.transformer = FSPagerViewTransformer(type: .linear)
                pagerView?.itemSize = CGSize(width: ScreenWidth - 40, height: 200)
                pagerView?.dataSource = self
                pagerView?.delegate = self
                pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BannerCell")
                cell.contentView.addSubview(pagerView!)
                
                // 通知栏
                headlineView = Bundle.main.loadNibNamed("HeadlineView", owner: nil, options: nil)?[0] as? HeadlineView
                headlineView?.frame = CGRect.init(x: 0, y: 250, width: ScreenWidth, height: 50)
                headlineView?.setIcon(UIImage.init(named: "gift"))
                headlineView?.setTitle("活动")
                headlineView?.delegate = self
                cell.contentView.addSubview(headlineView!)
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
        return adBanners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerCell", at: index)
        let adBanner = adBanners[index]
        cell.imageView?.sd_setImage(with: URL(string: baseURL + adBanner.imageURL), completed: nil)
        cell.textLabel?.text = adBanner.title
        return cell
    }
}

// MARK: NotificationDelegate
extension LifeVC: HeadlineViewDelegate {
    func headlineView(_ headlineView: HeadlineView, didSelectItemAt index: Int) {
        let notifi = notifications[index]
        view.makeToast("NotifiID: \(notifi.id ?? 0)")
    }
}
