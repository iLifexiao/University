//
//  Message.swift
//  App
//
//  Created by 肖权 on 2018/11/8.
//

import SwiftyJSON

struct Message {
    var id: Int?
    var userID: Int
    var friendID: Int
    var fromUserID: Int
    var toUserID: Int
    
    var content: String
    var type: String? // 类型「普通、系统」
    var status: Int? // 状态[0, 1, 2, 3] = [禁止、 未读、已读、删除]
    var createdAt: TimeInterval? // 创建时间
    
    init(id: Int? = nil, userID: Int, friendID: Int, fromUserID: Int, toUserID: Int, content: String, type: String? = "普通", status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.friendID = friendID
        self.fromUserID = fromUserID
        self.toUserID = toUserID
        self.content = content
        self.type = type
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        self.friendID = jsonData["id"].intValue
        self.fromUserID = jsonData["id"].intValue
        self.toUserID = jsonData["id"].intValue
       
        self.content = jsonData["content"].stringValue
        self.type = jsonData["type"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
    }
}
