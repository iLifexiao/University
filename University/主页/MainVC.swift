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
import Alamofire
import SwiftyJSON

class MainVC: UIViewController {
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    var pagerView: FSPagerView?
    var headlineView: HeadlineView?
    
    // UI配置
    let sectionCount = 3
    let bannerCell = "bannerCell"
    let dateCell = "dateCell"
    let campusCell = "campusCell"
    
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
    
    // 倒数日、校园服务
    var countdowns: [CountdownModel] = []
    var campusFuncs: [CampusFuncModel] = []
        
    // 日期默认
    var week: String = "星期三"
    var date: String = "2018-10-22"
    
    // MARK: 程序入口
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func initUI() {
        setupTableView()
    }
    
    private func initData() {
        // 软件初次使用配置
        firstUseSoft()
        
        // 载入用户ID信息、学籍绑定信息（下列API会在不存在的时候自动返回0）
        GlobalData.sharedInstance.userID = UserDefaults.standard.integer(forKey: userIDKey)
        GlobalData.sharedInstance.studentID = UserDefaults.standard.integer(forKey: studentIDKey)
        
        // 首页轮播图
        getADBanner()
        getNotifications()
        
        // 日期
        date = getFormatDate(format: "YYYY-MM-dd")
        week = getFormatDate(format: "EEEE")
        
        // countdown
        let countdown1 = CountdownModel(date: "2018-12-15", event: "CET-4", day: 33)
        let countdown2 = CountdownModel(date: "2018-12-25", event: "圣诞节", day: 43)
        let countdown3 = CountdownModel(date: "2019-01-01", event: "元旦节", day: 49)
        let countdown4 = CountdownModel(date: "2019-02-05", event: "春节", day: 85)
        countdowns = [countdown1, countdown2, countdown3, countdown4]
        
        // 校园服务
        let campusFuncModel = CampusFuncModel(icon: UIImage(named: "lesson"), name: "课程表")
        let campusFuncModel2 = CampusFuncModel(icon: UIImage(named: "grade"), name: "成绩查询")
        let campusFuncModel3 = CampusFuncModel(icon: UIImage(named: "classRoom"), name: "空教室")
        let campusFuncModel4 = CampusFuncModel(icon: UIImage(named: "library"), name: "图书馆")
        let campusFuncModel5 = CampusFuncModel(icon: UIImage(named: "education"), name: "考试安排")
        let campusFuncModel6 = CampusFuncModel(icon: UIImage(named: "speech"), name: "学术讲座")
        let campusFuncModel7 = CampusFuncModel(icon: UIImage(named: "cup"), name: "竞赛信息")
        let campusFuncModel8 = CampusFuncModel(icon: UIImage(named: "LostAndFound"), name: "失物招领")
        let campusFuncModel9 = CampusFuncModel(icon: UIImage(named: "calendar"), name: "校历")
        let campusFuncModel10 = CampusFuncModel(icon: UIImage(named: "eduArrange"), name: "教务通知")
        let campusFuncModel11 = CampusFuncModel(icon: UIImage(named: "community"), name: "社团")
        let campusFuncModel12 = CampusFuncModel(icon: UIImage(named: "directory"), name: "通讯录")
        campusFuncs = [campusFuncModel, campusFuncModel2, campusFuncModel3, campusFuncModel4, campusFuncModel5, campusFuncModel6, campusFuncModel7, campusFuncModel8, campusFuncModel9, campusFuncModel10, campusFuncModel11, campusFuncModel12]
    }
    
    // MARK: 入口调用方法
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
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.getADBanner()
            self?.getNotifications()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func firstUseSoft() {
        // 返回false表示第一次使用软件
        let isFirst = UserDefaults.standard.bool(forKey: firstUsedKey)
        // 第一次使用配置
        if !isFirst {
            UserDefaults.standard.set(true, forKey: firstUsedKey) // 非第一次使用
            UserDefaults.standard.set(0, forKey: userIDKey) //用户ID
            UserDefaults.standard.set(0, forKey: studentIDKey) //学生ID
            UserDefaults.standard.set(nil, forKey: accountKey) // 用户帐号
            UserDefaults.standard.set(true, forKey: autoLoginKey) //自动登录
        }
    }
    
    private func getADBanner() {
        Alamofire.request(baseURL + "/api/v1/adbanner/all/main", headers: headers).responseJSON { [weak self] response in
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
        Alamofire.request(baseURL + "/api/v1/notification/all/main", headers: headers).responseJSON { [weak self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
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
    
    private func getFormatDate(format: String) -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: now)
    }
}

// MARK: 主页-方法代理
extension MainVC: UITableViewDelegate {
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

// MARK: 主页-数据源代理
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
                pagerView = FSPagerView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250))
                pagerView?.automaticSlidingInterval = 3.0
                pagerView?.isInfinite = true
                // 显示的样式下，需要调整itemSize才能显示完全
//                pagerView?.transformer = FSPagerViewTransformer(type: .overlap)
//                pagerView?.itemSize = CGSize(width: ScreenWidth - 40, height: 200)
                pagerView?.dataSource = self
                pagerView?.delegate = self
                pagerView?.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BannerCell")
                cell.contentView.addSubview(pagerView!)
                
                // 通知栏
                headlineView = Bundle.main.loadNibNamed("HeadlineView", owner: nil, options: nil)?[0] as? HeadlineView                
                headlineView?.frame = CGRect.init(x: 0, y: 250, width: ScreenWidth, height: 50)
                headlineView?.delegate = self
                cell.contentView.addSubview(headlineView!)
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

// MARK: 滚动栏-方法代理
extension MainVC: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let adBanner = adBanners[index]
        view.makeToast("你选中的ID：\(adBanner.id ?? 0)")
    }
}

// MARK: 滚动栏-数据源代理
extension MainVC: FSPagerViewDataSource {
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

// MARK: 校园服务-方法代理
extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if GlobalData.sharedInstance.userID == 0 {
            let loginSB = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = loginSB.instantiateViewController(withIdentifier: "LoginVC")
            navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        
        if GlobalData.sharedInstance.studentID == 0 {
            let bandStudentVC = BandingStudentVC()
            navigationController?.pushViewController(bandStudentVC, animated: true)
            return
        }
        
        let campusFunc = campusFuncs[indexPath.row]
        switch campusFunc.name {
        case "课程表":
            let lessonTimeTable = LessonTimeTable()
            navigationController?.pushViewController(lessonTimeTable, animated: true)
        case "图书馆":
            let libraryWebVC = LibraryWebVC()
            navigationController?.pushViewController(libraryWebVC, animated: true)
        case "竞赛信息":
            let raceVC = RaceVC()
            navigationController?.pushViewController(raceVC, animated: true)
        case "教务通知":
            let acdemicVC = AcdemicVC()
            navigationController?.pushViewController(acdemicVC, animated: true)
        case "成绩查询":
            let lessonGradeVC = LessonGradeVC()
            navigationController?.pushViewController(lessonGradeVC, animated: true)
        case "考试安排":
            let examinationVC = ExaminationVC()
            navigationController?.pushViewController(examinationVC, animated: true)
        case "失物招领":
            let lostAndFoundVC = LostAndFoundVC()
            navigationController?.pushViewController(lostAndFoundVC, animated: true)
        case "社团":
            let clubVC = ClubVC()
            navigationController?.pushViewController(clubVC, animated: true)
        case "空教室":
            let emptyClassRoomVC = EmptyClassRoomVC()
            navigationController?.pushViewController(emptyClassRoomVC, animated: true)
        case "学术讲座":
            let speechVC = SpeechVC()
            navigationController?.pushViewController(speechVC, animated: true)
        case "校历":
            let schoolCalendarVC = SchoolCalendarVC()
            navigationController?.pushViewController(schoolCalendarVC, animated: true)
        case "通讯录":
            let addressListVC = AddressListVC()
            navigationController?.pushViewController(addressListVC, animated: true)
        default:
            view.makeToast("you select: \(campusFunc.name!)")
        }
    }
}

// MARK: 校园服务-数据源代理
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

// MARK: 滚动通知-方法代理
extension MainVC: HeadlineViewDelegate {
    func headlineView(_ headlineView: HeadlineView, didSelectItemAt index: Int) {
        let notifi = notifications[index]
        view.makeToast("NotifiID: \(notifi.id ?? 0)")
    }
}

// MARK: 倒数日-方法代理
extension MainVC: CountdownViewDelegate {
    func countdownView(_ countdownView: CountdownView, didSelectItemAt index: Int) {
        let countdown = countdowns[index]
        view.makeToast(countdown.event)
    }
}
