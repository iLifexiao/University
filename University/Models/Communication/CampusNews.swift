//
//  CampusNews.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct CampusNews {
    var id: Int?
    
    var imageURL: String
    var title: String
    var content: String
    var from: String // 来源：校内、网络等等
    var type: String // 科技、教育、社会等等
    
    var likeCount: Int?
    var commentCount: Int?
    var readCount: Int?

    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, imageURL: String, title: String, content: String, from: String, type: String, likeCount: Int? = 0, commentCount: Int? = 0, readCount: Int? = 0, status: Int? = 1) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.content = content
        self.from = from
        self.type = type
        self.readCount = readCount
        self.likeCount = likeCount
        self.commentCount = commentCount        
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.imageURL = jsonData["imageURL"].stringValue
        self.title = jsonData["title"].stringValue
        self.content = jsonData["content"].stringValue
        self.from = jsonData["from"].stringValue
        self.type = jsonData["type"].stringValue
        self.readCount = jsonData["readCount"].intValue
        self.likeCount = jsonData["likeCount"].intValue
        self.commentCount = jsonData["commentCount"].intValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
