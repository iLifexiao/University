//
//  UserVC.swift
//  大学说
//
//  Created by 肖权 on 2018/10/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

class UserVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    private var userView: UserView?
    private var weCulture: [MyServerModel] = []
    private var studentStatus: [MyServerModel] = []
    private var softSettings: [MyServerModel] = []
    
    // 因为API时异步返回，所以需要设置计算属性，在赋值的时候，完成UI界面的更新
    private var messageCount: Int {
        set {
            DispatchQueue.main.async {
                self.userView?.setMessageCount(newValue)
            }
        }
        get {
            return 0
        }
    }
    private var unreadMessageCount: Int {
        set {
            DispatchQueue.main.async {
                self.userView?.setUnreadMessage(count: newValue)
            }
        }
        get {
            return 0
        }
    }
    private var essayCount: Int {
        set {
            DispatchQueue.main.async {
                self.userView?.setEssayCount(newValue)
            }
        }
        get {
            return 0
        }
    }
    private var fansCount: Int {
        set {
            DispatchQueue.main.async {
                self.userView?.setFansCount(newValue)
            }
        }
        get {
            return 0
        }
    }
    private var collectionCount: Int {
        set {
            DispatchQueue.main.async {
                self.userView?.setCollectionCount(newValue)
            }
        }
        get {
            return 0
        }
    }
    
    let userCell = "userCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupTableView()
        
        // 添加更新通知的接收者
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserView(noti:)), name: NSNotification.Name(updateUserViewNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    private func initData() {
        // 用户相关(从网络获取)
        updateUserIMCountInfo()
        
        // 文化交流
        let culture1 = MyServerModel(icon: #imageLiteral(resourceName: "friends"), title: "我的好友")
        let culture2 = MyServerModel(icon: #imageLiteral(resourceName: "idea"), title: "我的经验")
        let culture3 = MyServerModel(icon: #imageLiteral(resourceName: "answer"), title: "我的问答")
        let culture4 = MyServerModel(icon: #imageLiteral(resourceName: "myBook"), title: "我的书籍")
        let culture5 = MyServerModel(icon: #imageLiteral(resourceName: "myResources"), title: "我的资源")
        weCulture = [culture1, culture2, culture3, culture4, culture5]
        
        // 学籍信息
        let schoolFunc1 = MyServerModel(icon: #imageLiteral(resourceName: "studentCard"), title: "我的学籍")
        let schoolFunc2 = MyServerModel(icon: #imageLiteral(resourceName: "myGrade"), title: "我的成绩")
        let schoolFunc3 = MyServerModel(icon: #imageLiteral(resourceName: "myHonor"), title: "我的荣誉")
        studentStatus = [schoolFunc1 ,schoolFunc2, schoolFunc3]
        
        // 软件设置
        let softset1 = MyServerModel(icon: #imageLiteral(resourceName: "settings"), title: "软件设置")
        softSettings = [softset1]
        
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: userCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        // 下拉刷新
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            // 重新获取
            self?.updateUserIMCountInfo()
            
            self?.tableView.mj_header.endRefreshing()
            self?.view.makeToast("刷新成功", position: .top)
        }
    }
    
    private func updateUserIMCountInfo() {
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/messages/count", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.messageCount = json["data"]["value"].intValue
            case .failure(let error):
                print(error)
            }
        }
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/messages/unread/count", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.unreadMessageCount = json["data"]["value"].intValue
            case .failure(let error):
                print(error)
            }
        }
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/essays/count", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.essayCount = json["data"]["value"].intValue
            case .failure(let error):
                print(error)
            }
        }
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/fans/count", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.fansCount = json["data"]["value"].intValue
            case .failure(let error):
                print(error)
            }
        }
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/collections/count", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.collectionCount = json["data"]["value"].intValue
            case .failure(let error):
                print(error)
            }
        }
        
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/userInfo", headers: headers).responseJSON { [weak self] response in
            guard let self = self else {
                return
            }
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let userInfo = UserInfo(jsonData: json);
                // 需要在主线程中
                DispatchQueue.main.async {
                    // 顺便更新头像和名字
                    self.userView?.setUserName(userInfo.nickname)
                    self.userView?.setUserHead(userInfo.profilephoto)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // 接收通知
    @objc func updateUserView(noti: NSNotification) {
        let info = noti.userInfo as? [String: String]
        userView?.setUserName(info?["userName"])
        userView?.setUserHead(info?["headImage"])
        
        // 使用一个结构体来完成? 采用API返回，异步返回
        updateUserIMCountInfo()
    }
    
    @IBAction func userSettingPress(_ sender: UIBarButtonItem) {
        let settingVC = SettingVC()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
}

extension UserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        switch indexPath.section {
        case 0:
            let detailVC = DetailUserVC()
            detailVC.userID = GlobalData.sharedInstance.userID
            navigationController?.pushViewController(detailVC, animated: true)
        case 1:
            switch indexPath.row {
            case 0:
                let iFriendVC = IFriendsVC()
                navigationController?.pushViewController(iFriendVC, animated: true)
            case 1:
                let iExperienceVC = IExperienceVC()
                navigationController?.pushViewController(iExperienceVC, animated: true)
            case 2:
                let iQANDAnswerVC = IQANDAnswerVC()
                navigationController?.pushViewController(iQANDAnswerVC, animated: true)
            case 3:
                let iBookVC = IBookVC()
                navigationController?.pushViewController(iBookVC, animated: true)
            case 4:
                let iResourcesVC = IResourcesVC()
                navigationController?.pushViewController(iResourcesVC, animated: true)
            default:
                print("不是这里哦")
            }
        case 2:
            switch indexPath.row {
            case 0:
                let iStudentVC = IStudentVC()
                navigationController?.pushViewController(iStudentVC, animated: true)
            case 1:
                let iLessonGradeVC = ILessonGradeVC()
                navigationController?.pushViewController(iLessonGradeVC, animated: true)
            case 2:
                let iHonorVC = IHonorVC()
                navigationController?.pushViewController(iHonorVC, animated: true)
            default:
                print("不是这里哦")
            }
        case 3:
            switch indexPath.row {
            case 0:
                let settingVC = SettingVC()
                navigationController?.pushViewController(settingVC, animated: true)
            default:
                print("不是这里哦")
            }
        default:
            print("不是这里哦")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 290
        default:
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 20
        default:
            return 10
        }
    }
}

extension UserVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return weCulture.count
        case 2:
            return studentStatus.count
        case 3:
            return softSettings.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
            if cell.contentView.subviews.count == 0 {
                userView = Bundle.main.loadNibNamed("UserView", owner: nil, options: nil)?[0] as? UserView
                userView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 300)
                userView?.delegate = self
                
                userView?.setUserName(GlobalData.sharedInstance.userName)
                userView?.setUserHead(GlobalData.sharedInstance.userHeadImage)
                
                userView?.setMessageCount(messageCount)
                userView?.setEssayCount(essayCount)
                userView?.setFansCount(fansCount)
                userView?.setCollectionCount(collectionCount)
                cell.contentView.addSubview(userView!)
            }
            cell.accessoryType = .none
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            let model = weCulture[indexPath.row]
            cell.imageView?.image = model.icon
            cell.textLabel?.text = model.title
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            let model = studentStatus[indexPath.row]
            cell.imageView?.image = model.icon
            cell.textLabel?.text = model.title
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            let model = softSettings[indexPath.row]
            cell.imageView?.image = model.icon
            cell.textLabel?.text = model.title
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            cell.selectionStyle = .none
            return cell
        }

    }
}

extension UserVC: UserViewDelegate {
    func userViewFuncClick(_ funcName: String) {
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
        
        
        switch funcName {
        case "私信":
            let iMessageVC = IMessageVC()
            navigationController?.pushViewController(iMessageVC, animated: true)
        case "文章":
            let iEssayVC = IEssayVC()
            navigationController?.pushViewController(iEssayVC, animated: true)
        case "粉丝":
            let iFansVC = IFansVC()
            navigationController?.pushViewController(iFansVC, animated: true)
        case "收藏":
            let iCollectionVC = ICollectionVC()
            navigationController?.pushViewController(iCollectionVC, animated: true)
        default:
            print("Error of FuncName")
        }
    }
}
