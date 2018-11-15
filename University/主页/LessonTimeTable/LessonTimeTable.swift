//
//  LessonTimeTable.swift
//  University
//
//  Created by 肖权 on 2018/11/12.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CurriculaTable

class LessonTimeTable: UIViewController {

    @IBOutlet weak var curriculaTable: CurriculaTable!
    
    var curriculaItems: [CurriculaTableItem] = []
    var lessons: [Lesson] = []
    
    // 获取lesson完成后，设置课程表，起到通知的效果
    var lessonGetDone: Int {
        set {
            for lesson in lessons {
                let period = dayStringMap(lesson.timeInDay)
                let item = CurriculaTableItem(name: lesson.name, place: lesson.site, weekday: weekStringMap(lesson.timeInWeek), startPeriod: period.0, endPeriod: period.1, textColor: UIColor.white, bgColor: UIColor.randomColor, identifier: String(lesson.id!), tapHandler: handler)
                curriculaItems.append(item)
            }
            curriculaTable.curricula = curriculaItems
        }
        get {
            return lessons.count
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initUI() {
        title = "课程表"
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrow_down"), style: .plain, target: self, action: #selector(changeYear))
        setupCurriculum()
    }
    
    private func initData() {
        getLessons()
    }
    
    private func setupCurriculum() {
        curriculaTable.bgColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1.0)
        curriculaTable.borderWidth = 0.5
        curriculaTable.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.9)
        curriculaTable.cornerRadius = 5
        curriculaTable.textEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        curriculaTable.maximumNameLength = 12
        curriculaTable.numberOfPeriods = 8
    }
    
    private func getLessons() {
        MBProgressHUD.showAdded(to: view, animated: true)
        Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/student/lesson", headers: headers).responseJSON { [weak self] response in
            if let self = self {
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    self.lessons.removeAll()
                    for (_,subJson):(String, JSON) in json {
                        self.lessons.append(Lesson(jsonData: subJson))
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.lessonGetDone = 1
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func changeYear() {
        
    }
    
    private func weekStringMap(_ week: String) -> CurriculaTableWeekday {
        switch week {
        case "周一":
            return CurriculaTableWeekday.monday
        case "周二":
            return CurriculaTableWeekday.tuesday
        case "周三":
            return CurriculaTableWeekday.wednesday
        case "周四":
            return CurriculaTableWeekday.thursday
        case "周五":
            return CurriculaTableWeekday.friday
        case "周六":
            return CurriculaTableWeekday.saturday
        case "周日":
            return CurriculaTableWeekday.sunday
        default:
            return CurriculaTableWeekday.monday
        }
    }
    
    private func dayStringMap(_ day: String) -> (Int, Int) {
        switch day {
        case "第1,2节":
            return (1, 2)
        case "第3,4节":
            return (3, 4)
        case "第5,6节":
            return (5, 6)
        case "第7,8节":
            return (7, 8)
        default:
            return (1, 2)
        }
    }
    
    // 课表点击事件
    let handler = { (curriculum: CurriculaTableItem) in
        print(curriculum.name, curriculum.identifier)
    }
    
}
