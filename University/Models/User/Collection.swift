//
//  Collection.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Collection {
    var id: Int?
    var userID: Int
    
    var collectionID: Int
    var type: String // 收藏的类型[Resource、Essay、CampusNews、Book、Question、Answer、Experience]
    
    var status: Int? // 状态[0, 1] = [失效, 正常]
    var createdAt: TimeInterval? // 收藏时间
    
    
    init(id: Int? = nil, userID: Int, collectionID: Int, type: String, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.collectionID = collectionID
        self.type = type
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        self.collectionID = jsonData["collectionID"].intValue
        
        self.type = jsonData["type"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue        
    }
}

