//
//  Book.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Book {
    var id: Int?
    var userID: Int // 也可分为系统推荐
    
    var name: String
    var imageURL: String
    var introduce: String
    var type: String
    var author: String
    var bookPages: Int
    
    var readedCount: Int?
    var likeCount: Int?
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, userID: Int, name: String, imageURL: String, introduce: String, type: String, author: String, bookPages: Int, readedCount: Int? = 0, likeCount: Int? = 0, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.name = name
        self.imageURL = imageURL
        self.introduce = introduce
        self.type = type
        self.author = author
        self.bookPages = bookPages
        self.readedCount = readedCount
        self.likeCount = likeCount
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.name = jsonData["title"].stringValue
        self.imageURL = jsonData["imageURL"].stringValue
        self.introduce = jsonData["introduce"].stringValue
        self.type = jsonData["type"].stringValue
        self.author = jsonData["author"].stringValue
        self.bookPages = jsonData["bookPages"].intValue
        self.readedCount = jsonData["readedCount"].intValue
        self.likeCount = jsonData["likeCount"].intValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
