//
//  UserVC.swift
//  大学说
//
//  Created by 肖权 on 2018/10/19.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Toast_Swift

class UserVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    private var weCulture: [MyServerModel] = []
    private var studentStatus: [MyServerModel] = []
    
    private var messageCount: Int?
    private var essayCount: Int?
    private var fansCount: Int?
    private var collectionCount: Int?
    
    let userCell = "userCell"
    
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
        // 用户相关
        messageCount = 3
        essayCount = 25
        fansCount = 234
        collectionCount = 13
        
        // 文化交流
        let culture1 = MyServerModel(icon: UIImage.init(named: "friends"), title: "我的好友")
        let culture2 = MyServerModel(icon: UIImage.init(named: "idea"), title: "我的经验")
        let culture3 = MyServerModel(icon: UIImage.init(named: "answer"), title: "我的问答")
        weCulture = [culture1, culture2, culture3]
        
        // 学籍信息
        let schoolFunc1 = MyServerModel(icon: UIImage.init(named: "studentCard"), title: "我的学籍")
        let schoolFunc2 = MyServerModel(icon: UIImage.init(named: "myGrade"), title: "我的成绩")
        let schoolFunc3 = MyServerModel(icon: UIImage.init(named: "myHonner"), title: "我的荣誉")
        studentStatus = [schoolFunc1 ,schoolFunc2, schoolFunc3]
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: userCell)
        
        // 适配不同系统下的偏移问题
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    @IBAction func userSettingPress(_ sender: UIBarButtonItem) {
        view.makeToast("设置")
        UserDefaults.standard.set(0, forKey: userIDKey)
        UserDefaults.standard.set(0, forKey: studentIDKey)
        GlobalData.sharedInstance.userID = 0
        GlobalData.sharedInstance.studentID = 0
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return weCulture.count
        case 2:
            return studentStatus.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath)
            if cell.contentView.subviews.count == 0 {
                let userView = Bundle.main.loadNibNamed("UserView", owner: nil, options: nil)?[0] as! UserView
                userView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: 300)
                userView.delegate = self
                userView.setUserName(GlobalData.sharedInstance.userName)
                userView.setUserHead(GlobalData.sharedInstance.userHeadImage)
                userView.setMessageCount(messageCount)
                userView.setEssayCount(essayCount)
                userView.setFansCount(fansCount)
                userView.setCollectionCount(collectionCount)
                cell.contentView.addSubview(userView)
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
