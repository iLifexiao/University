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
import SwiftDate
import SCLAlertView

class MainVC: UIViewController {
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    
    // 1. Banner
    lazy var pagerView: FSPagerView = {
        let pager = FSPagerView(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 250))
        pager.automaticSlidingInterval = 3.0
        pager.isInfinite = true
        pager.dataSource = self
        pager.delegate = self
        pager.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "BannerCell")
        return pager
    }()
    
    // 2. 新闻栏
    lazy var headlineView: HeadlineView = {
        let headline = Bundle.main.loadNibNamed("HeadlineView", owner: nil, options: nil)?[0] as? HeadlineView
        headline?.frame = CGRect.init(x: 0, y: 250, width: ScreenWidth, height: 50)
        headline?.delegate = self
        return headline!
    }()
    
    // 3. 倒数日
    lazy var countdownView: CountdownView = {
        let countDownView = Bundle.main.loadNibNamed("CountdownView", owner: nil, options: nil)?[0] as! CountdownView
        countDownView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 100)
        countDownView.delegate = self
        return countDownView
    }()
    
    // UI配置
    let sectionCount = 3
    let bannerCell = "bannerCell"
    let dateCell = "dateCell"
    let campusCell = "campusCell"
    
    // 网络数据
    private var adBanners: [ADBanner] = []
    private var notifications: [Notification] = []
    private var dateEvent: [(String, String)] = []
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
    private var countdowns: [CountdownModel] = []
    private var campusFuncs: [CampusFuncModel] = []
        
    // 日期默认
    private var week: String = "星期三"
    private var date: String = "2018-10-22"
    
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
        
        GlobalData.sharedInstance.userName = UserDefaults.standard.string(forKey: userNameKey) ?? "用户未登录"
        GlobalData.sharedInstance.userHeadImage = UserDefaults.standard.string(forKey: userHeadKey) ?? "/image/defalut.png"
        
        // 首页轮播图
        getADBanner()
        getNotifications()
        
        // 日期
        getHolidays()
        
        date = Date().toFormat("YYYY-MM-dd")
        week = Date().toFormat("EEEE")
        
        // 校园服务
        let campusFuncModel = CampusFuncModel(icon: #imageLiteral(resourceName: "lesson"), name: "课程表")
        let campusFuncModel2 = CampusFuncModel(icon: #imageLiteral(resourceName: "grade"), name: "成绩查询")
//        let campusFuncModel3 = CampusFuncModel(icon: UIImage(named: "classRoom"), name: "空教室"), campusFuncModel3
        let campusFuncModel4 = CampusFuncModel(icon: #imageLiteral(resourceName: "library"), name: "图书馆")
        let campusFuncModel5 = CampusFuncModel(icon: #imageLiteral(resourceName: "education"), name: "考试安排")
        let campusFuncModel6 = CampusFuncModel(icon: #imageLiteral(resourceName: "speech"), name: "学术讲座")
        let campusFuncModel7 = CampusFuncModel(icon: #imageLiteral(resourceName: "cup"), name: "竞赛信息")
        let campusFuncModel8 = CampusFuncModel(icon: #imageLiteral(resourceName: "LostAndFound"), name: "失物招领")
        let campusFuncModel9 = CampusFuncModel(icon: #imageLiteral(resourceName: "calendar"), name: "校历")
        let campusFuncModel10 = CampusFuncModel(icon: #imageLiteral(resourceName: "eduArrange"), name: "教务通知")
        let campusFuncModel11 = CampusFuncModel(icon: #imageLiteral(resourceName: "community"), name: "社团")
        let campusFuncModel12 = CampusFuncModel(icon: #imageLiteral(resourceName: "notebook"), name: "通讯录")
        campusFuncs = [campusFuncModel, campusFuncModel2, campusFuncModel4, campusFuncModel5, campusFuncModel6, campusFuncModel7, campusFuncModel8, campusFuncModel9, campusFuncModel10, campusFuncModel11, campusFuncModel12]
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
            self?.getHolidays()
            
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
            
            // 默认用户信息
            UserDefaults.standard.set("用户未登录", forKey: userNameKey)
            UserDefaults.standard.set("/image/defalut.png", forKey: userHeadKey)
        }
    }
    
    private func getADBanner() {
        Alamofire.request(baseURL + "/api/v1/adbanner/all/main", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.adBanners.removeAll()
                // json是数组
                for (_,subJson):(String, JSON) in json {
                    self.adBanners.append(ADBanner(jsonData: subJson))
                }
                self.pagerView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getNotifications() {
        Alamofire.request(baseURL + "/api/v1/notification/all/main", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.notifications.removeAll()
                for (_,subJson):(String, JSON) in json {
                    self.notifications.append(Notification(jsonData: subJson))
                }
                self.headlineView.setNews(self.news)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getHolidays() {
        Alamofire.request(baseURL + "/api/v1/holiday/all", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                // 设置事件
                self.dateEvent.removeAll()
                for (_,subJson):(String, JSON) in json {
                    let holiday = Holiday(jsonData: subJson)
                    self.dateEvent.append((holiday.name, holiday.time))
                }
                // 排序(按照日期正序)
                // 采用函数式编程方式
                self.dateEvent.sort(by: { (event1, event2) -> Bool in
                    event1.1 < event2.1
                })
                
                // countdown
                self.getCountDown(count: 6)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 获取倒数日
    private func getCountDown(count: Int) {
        
        // (事件, 2018-12-02)
        var events: [(String, String)] = []
        
        // 日期成分
        let todayDate = Date().toFormat("YYYY-MM-dd")
        let today = Date() // 比较的日期
        let year = today.year
        let month = today.month
        let day = today.day
        
        // 日期格式
        var monthStr = String(month)
        var dayStr = String(day)
        
        // 更改格式
        if month < 10 {
            monthStr = "0" + String(month)
        }
        
        if day < 10 {
            dayStr = "0" + String(day)
        }
        
        let currentMMdd = monthStr + "-" + dayStr
        // 记录当前日期在事件列表里的位置（小于它的均为明年，反之为今年）
        var currentMMddIndex = 0
        for event in dateEvent {
            if event.1 < currentMMdd {
                currentMMddIndex += 1
            }
        }
        
        // 添加显示的事件
        let dateEventCount = dateEvent.count // 日期事件的个数
        for index in currentMMddIndex..<(count + currentMMddIndex) {
            // 超过范围的为下一年
            if index > dateEventCount - 1 {
                let event = dateEvent[index % dateEventCount]
                events.append((event.0, String(year + 1) + "-" + event.1))
            } else {
                let event = dateEvent[index]
                events.append((event.0, String(year) + "-" + event.1))
            }
        }
        
        // 计算日期距离
        // let days = dateA.getInterval(toDate: dateB, component: .day)
        var eventDistancesDay: [Int] = []
        for event in events {
            let dateOfEvent = event.1
            // 需要转换为 DateInRegion 才能计算
            let today = DateInRegion(todayDate)!
            let anotherDay = DateInRegion(dateOfEvent)!
            let days = today.getInterval(toDate: anotherDay, component: .day)
            eventDistancesDay.append(Int(days))
        }
        
        // 组合
        countdowns.removeAll()
        for index in 0..<count {
            let countdown = CountdownModel(date: events[index].1, event: events[index].0, day: eventDistancesDay[index])
            countdowns.append(countdown)
        }
        
        // 清空 & 赋值 & 刷新
        countdownView.countdowns.removeAll()
        countdownView.countdowns = countdowns
        countdownView.reloadData()
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
        // 末尾不显示
        if section == sectionCount - 1 {
            return 0
        }
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
                cell.contentView.addSubview(pagerView)
                
                // 通知栏
                cell.contentView.addSubview(headlineView)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCell, for: indexPath)
            if cell.contentView.subviews.count == 0 {
                // 倒数日
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
        // 跳转到对应的WEB页面
        let webVC = WebVC()
        webVC.url = adBanner.link
        navigationController?.pushViewController(webVC, animated: true)
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
        // 检测用户是否登录 & 是否绑定学籍帐号
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
//        case "空教室":
//            let emptyClassRoomVC = EmptyClassRoomVC()
//            navigationController?.pushViewController(emptyClassRoomVC, animated: true)
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
        SCLAlertView().showInfo("通知详细", subTitle: notifi.content)
    }
}

// MARK: 倒数日-方法代理
extension MainVC: CountdownViewDelegate {
    func countdownView(_ countdownView: CountdownView, didSelectItemAt index: Int) {
        let countdown = countdowns[index]
        view.makeToast(countdown.event)
    }
}
