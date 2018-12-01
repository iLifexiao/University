//
//  Comment.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Comment {
    var id: Int?
    var userID: Int
    var commentID: Int
    
    // 新增用户信息
    var nickname: String?
    var profilephoto: String?
    
    var content: String
    var type: String // [Resource, Essay, CampusNews, Book, Question, Answer, Experience]
    
    var likeCount: Int?
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, userID: Int, content: String, likeCount: Int = 0, type: String, commentID: Int, status: Int = 1) {
        self.id = id
        self.userID = userID
        self.content = content
        self.likeCount = likeCount
        self.type = type
        self.commentID = commentID
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        self.commentID = jsonData["commentID"].intValue
        
        self.nickname = jsonData["userInfo"]["nickname"].stringValue
        self.profilephoto = jsonData["userInfo"]["profilephoto"].stringValue
        
        self.content = jsonData["content"].stringValue        
        self.type = jsonData["type"].stringValue        
        self.likeCount = jsonData["likeCount"].intValue
        
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
