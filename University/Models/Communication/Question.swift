//
//  Question.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Question {
    var id: Int?
    var userID: Int
    
    var title: String
    var type: String
    var from: String // 来源
    
    var answerCount: Int?
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, userID: Int, title: String, type: String, from: String, answerCount: Int? = 0, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.title = title
        self.type = type
        self.from = from
        self.answerCount = answerCount
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.title = jsonData["title"].stringValue
        self.type = jsonData["content"].stringValue
        self.from = jsonData["time"].stringValue
        self.answerCount = jsonData["answerCount"].intValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
