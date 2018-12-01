//
//  Answer.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Answer {
    var id: Int?
    var userID: Int
    var questionID: Int
    
    // 新增用户信息
    var nickname: String?
    var profilephoto: String?
    
    var content: String
    
    var readCount: Int?
    var commentCount: Int?
    var likeCount: Int?
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var remark: String? // 备注
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, userID: Int, questionID: Int, content: String, readCount: Int? = 0, commentCount: Int? = 0, likeCount: Int? = 0, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.questionID = questionID
        self.content = content
        self.readCount = readCount
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        self.questionID = jsonData["questionID"].intValue
        
        self.nickname = jsonData["userInfo"]["nickname"].stringValue
        self.profilephoto = jsonData["userInfo"]["profilephoto"].stringValue
        
        self.content = jsonData["content"].stringValue
        self.readCount = jsonData["readCount"].intValue
        self.commentCount = jsonData["commentCount"].intValue
        self.likeCount = jsonData["likeCount"].intValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
