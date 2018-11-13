//
//  LessonGrade.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct LessonGrade {
    var id: Int?
    var studentID: Int
    var scheduleID: Int
    
    var no: String
    var name: String
    var type: String
    var credit: Float
    var gradePoint: Float
    var grade: Float
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间    
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, studentID: Int, scheduleID: Int, no: String, name: String, type: String, credit: Float, gradePoint: Float, grade: Float, remark: String?, status: Int? = 1) {
        self.id = id
        self.studentID = studentID
        self.scheduleID = scheduleID
        self.no = no
        self.name = name
        self.type = type
        self.credit = credit
        self.gradePoint = gradePoint
        self.grade = grade
        self.remark = remark
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.studentID = jsonData["studentID"].intValue
        self.scheduleID = jsonData["scheduleID"].intValue
        
        self.no = jsonData["no"].stringValue
        self.name = jsonData["name"].stringValue
        self.type = jsonData["type"].stringValue
        self.credit = jsonData["credit"].floatValue
        self.gradePoint = jsonData["gradePoint"].floatValue
        self.grade = jsonData["grade"].floatValue
        self.remark = jsonData["remark"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
