//
//  Honor.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Honor {
    var id: Int?
    var userID: Int
    
    var name: String
    var rank: String
    var time: String // 获得时间
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]    
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
        
    init(id: Int? = nil, userID: Int, name: String, rank: String, time: String, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.name = name
        self.rank = rank
        self.time = time
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.name = jsonData["name"].stringValue
        self.rank = jsonData["rank"].stringValue
        self.time = jsonData["time"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
