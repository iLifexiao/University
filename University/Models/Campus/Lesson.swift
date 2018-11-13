//
//  Lesson.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Lesson {
    var id: Int?
    var studentID: Int
    var scheduleID: Int
    
    var timeInWeek: String
    var timeInDay: String
    var timeInTerm: String
    var name: String
    var teacher: String
    var site: String
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, studentID: Int, scheduleID: Int, timeInWeek: String, timeInDay: String, timeInTerm: String, name: String, teacher: String, site: String, remark: String?, status: Int? = 1) {
        self.id = id
        self.studentID = studentID
        self.scheduleID = scheduleID
        self.timeInWeek = timeInWeek
        self.timeInDay = timeInDay
        self.timeInTerm = timeInTerm
        self.name = name
        self.teacher = teacher
        self.site = site
        self.remark = remark
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.studentID = jsonData["studentID"].intValue
        self.scheduleID = jsonData["scheduleID"].intValue
        
        self.timeInWeek = jsonData["timeInWeek"].stringValue
        self.timeInDay = jsonData["timeInDay"].stringValue
        self.timeInTerm = jsonData["timeInTerm"].stringValue
        self.name = jsonData["name"].stringValue
        self.teacher = jsonData["teacher"].stringValue
        self.site = jsonData["site"].stringValue
        self.remark = jsonData["remark"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
