//
//  LessonSchedule.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct LessonSchedule {
    var id: Int?
    var studentID: Int
    
    var year: String
    var term: String
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, studentID: Int, year: String, term: String, remark: String?, status: Int = 1) {
        self.id = id
        self.studentID = studentID
        self.year = year
        self.term = term
        self.remark = remark
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.studentID = jsonData["studentID"].intValue
        
        self.year = jsonData["year"].stringValue
        self.term = jsonData["term"].stringValue
        self.remark = jsonData["remark"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
