//
//  Experience.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Experience {
    var id: Int?
    var userID: Int
    
    var title: String
    var content: String
    var type: String
    
    var readCount: Int?
    var commentCount: Int?
    var likeCount: Int?
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, userID: Int, title: String, content: String, type: String, readCount: Int? = 0, commentCount: Int? = 0, likeCount: Int? = 0, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.title = title
        self.content = content
        self.type = type
        self.readCount = readCount
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.title = jsonData["title"].stringValue
        self.content = jsonData["content"].stringValue
        self.type = jsonData["type"].stringValue
        self.readCount = jsonData["readCount"].intValue
        self.likeCount = jsonData["likeCount"].intValue
        self.commentCount = jsonData["commentCount"].intValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
