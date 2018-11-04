//
//  MainVC.swift
//  大学说
//
//  Created by 肖权 on 2018/10/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage
import Toast_Swift

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!    
    var bannerImages: [URL] = []
    var countdowns: [CountdownModel] = []
    var campusFuncs: [CampusFuncModel] = []
//    var adModels: [ADModel] = []
    
    let sectionCount = 3
    let bannerCell = "bannerCell"
    let dateCell = "dateCell"
    let campusCell = "campusCell"
    
    // 日期默认
    var week: String = "星期三"
    var date: String = "2018-10-22"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        initData()
    }
    
    private func initData() {
        // banner
        for index in 0...4 {
            if let url = URL(string: "https://picsum.photos/375/200/?image=\(100+index)") {
                bannerImages.append(url)
            }
        }
        
        // 日期
        date = getFormatDate(format: "YYYY-MM-dd")
        week = getFormatDate(format: "EEEE")
        
        // countdown
        let countdown1 = CountdownModel(date: "2018-12-15", event: "CET-4", day: 49)
        let countdown2 = CountdownModel(date: "2018-12-25", event: "圣诞节", day: 59)
        let countdown3 = CountdownModel(date: "2019-01-01", event: "元旦节", day: 65)
        let countdown4 = CountdownModel(date: "2019-02-05", event: "春节", day: 101)
        countdowns = [countdown1, countdown2, countdown3, countdown4]
        
        // 校园服务
        let campusFuncModel = CampusFuncModel(icon: UIImage.init(named: "lesson"), name: "课程表")
        let campusFuncModel2 = CampusFuncModel(icon: UIImage.init(named: "grade"), name: "成绩查询")
        let campusFuncModel3 = CampusFuncModel(icon: UIImage.init(named: "classRoom"), name: "空教室")
        let campusFuncModel4 = CampusFuncModel(icon: UIImage.init(named: "library"), name: "图书馆")
        let campusFuncModel5 = CampusFuncModel(icon: UIImage.init(named: "education"), name: "考试安排")
        let campusFuncModel6 = CampusFuncModel(icon: UIImage.init(named: "speech"), name: "学术讲座")
        let campusFuncModel7 = CampusFuncModel(icon: UIImage.init(named: "cup"), name: "竞赛信息")
        let campusFuncModel8 = CampusFuncModel(icon: UIImage.init(named: "LostAndFound"), name: "失物招领")
        let campusFuncModel9 = CampusFuncModel(icon: UIImage.init(named: "calendar"), name: "校历")
        let campusFuncModel10 = CampusFuncModel(icon: UIImage.init(named: "eduArrange"), name: "教务通知")
        let campusFuncModel11 = CampusFuncModel(icon: UIImage.init(named: "community"), name: "社团")
        let campusFuncModel12 = CampusFuncModel(icon: UIImage.init(named: "directory"), name: "通讯录")
        campusFuncs = [campusFuncModel, campusFuncModel2, campusFuncModel3, campusFuncModel4, campusFuncModel5, campusFuncModel6, campusFuncModel7, campusFuncModel8, campusFuncModel9, campusFuncModel10, campusFuncModel11, campusFuncModel12]
        
    }
    
    private func getFormatDate(format: String) -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: now)
    }
    
    private func setupTableView() {
        // 每一个复用的Cell都需要注册，发现通过代码创建的cell有复用问题
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: bannerCell)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: dateCell)
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: campusCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

}

// MARK: UITableViewDelegate
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        view.makeToast("you Select:\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
        case 1:
            return 100
        case 2:
            return 300
        default:
            return 100
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
    
    // HeadView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            let dateHeaderView = Bundle.main.loadNibNamed("DateHeaderView", owner: nil, options: nil)?[0] as! DateHeaderView
            dateHeaderView.setWeek(week)
            dateHeaderView.setDate(date)
            return dateHeaderView
        case 2:
            let tipsHeaderView = Bundle.main.loadNibNamed("TipsHeaderView", owner: nil, options: nil)?[0] as! TipsHeaderView
            return tipsHeaderView
        default:
            return nil
        }
    }
    
    // HeadView-height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 50
        }
    }
}

// MARK: UITableViewDataSource
extension MainVC: UITableViewDataSource {
    
    // 将主页分为四个区域（banner、日期、校园、推荐）
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
                pagerView.transformer = FSPagerViewTransformer(type: .overlap)
                pagerView.itemSize = CGSize(width: ScreenWidth - 40, height: 200)
                pagerView.dataSource = self
                pagerView.delegate = self
                pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BannerCell")
                cell.contentView.addSubview(pagerView)
                
                // 通知栏
                let headlineView = Bundle.main.loadNibNamed("HeadlineView", owner: nil, options: nil)?[0] as! HeadlineView
                headlineView.frame = CGRect.init(x: 0, y: 250, width: ScreenWidth, height: 50)
                headlineView.delegate = self
                headlineView.setNews(["庆祝学校建校40周年", "显示的样式下，需要调整itemSize才能显示完全", "大学说V1.0更新说明"])
                cell.contentView.addSubview(headlineView)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCell, for: indexPath)
            if cell.contentView.subviews.count == 0 {
                let countdownView = Bundle.main.loadNibNamed("CountdownView", owner: nil, options: nil)?[0] as! CountdownView
                countdownView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 100)
                countdownView.delegate = self
                countdownView.countdowns = countdowns
                cell.contentView.addSubview(countdownView)
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            // 校园服务
            let cell = tableView.dequeueReusableCell(withIdentifier: campusCell, for: indexPath)
            if cell.contentView.subviews.count == 0 {
                // 1. 布局设置
                let flowLayout = UICollectionViewFlowLayout()
                flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                flowLayout.minimumLineSpacing = 20;
                flowLayout.minimumInteritemSpacing = 20;
                flowLayout.itemSize = CGSize(width: 80, height: 80)
                flowLayout.scrollDirection = .horizontal
                
                // 2. collectionView初始化 + 布局
                let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 300), collectionViewLayout: flowLayout)
                collectionView.backgroundColor = .white
                collectionView.showsHorizontalScrollIndicator = false
                collectionView.showsVerticalScrollIndicator = false
                
                // 3. 实现代理
                collectionView.dataSource = self
                collectionView.delegate = self
                
                // 4. 注册Cell
                collectionView.register(UINib.init(nibName: "CampusFuncCell", bundle: nil), forCellWithReuseIdentifier: "CampusFuncCell")
                cell.contentView.addSubview(collectionView)
            }
            
            cell.selectionStyle = .none
            return cell
        default:
            // 默认空白的
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }

    }
}

// MARK: FSPagerViewDelegate
// Banner的Delegate
extension MainVC: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        view.makeToast("你选中了：\(index)")
    }
}

// MARK: FSPagerViewDataSource
// Banner的DetaSource
extension MainVC: FSPagerViewDataSource {
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

// MARK: UICollectionViewDelegate
// CampusServers
extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.makeToast("you select: \(indexPath.row)")
    }
}

// MARK: UICollectionViewDataSource
extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return campusFuncs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CampusFuncCell", for: indexPath) as! CampusFuncCell
        cell.setupData(campusFuncs[indexPath.row])
        return cell
    }
}

// MARK: HeadlineViewDelegate
extension MainVC: HeadlineViewDelegate {
    func headlineView(_ headlineView: HeadlineView, didSelectItemAt index: Int) {
        view.makeToast("news: \(index)")
    }
}

// MARK: ContdownViewDelegate
extension MainVC: CountdownViewDelegate {
    func countdownView(_ countdownView: CountdownView, didSelectItemAt index: Int) {
        let countdown = countdowns[index]
        view.makeToast(countdown.event)
    }
}
