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

    private var weCulture: [MyServerModel] = []
    private var studentStatus: [MyServerModel] = []
    
    private var messageCount: Int?
    private var essayCount: Int?
    private var fansCount: Int?
    private var collectionCount: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
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
        let schoolFunc4 = MyServerModel(icon: UIImage.init(named: "myCup"), title: "我的比赛")
        studentStatus = [schoolFunc1 ,schoolFunc2, schoolFunc3, schoolFunc4]
    }
    
    @IBAction func userSettingPress(_ sender: UIBarButtonItem) {
        view.makeToast("设置")
    }
    
}

extension UserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        view.makeToast("section: \(indexPath.section), row: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 300
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            if cell.contentView.subviews.count == 0 {
                let userView = Bundle.main.loadNibNamed("UserView", owner: nil, options: nil)?[0] as! UserView
                userView.delegate = self
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
        switch funcName {
        case "私信":
            view.makeToast(funcName)
        case "文章":
            view.makeToast(funcName)
        case "粉丝":
            view.makeToast(funcName)
        case "收藏":
            view.makeToast(funcName)
        default:
            print("Error of FuncName")
        }
    }
}
