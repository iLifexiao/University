//
//  Focus.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Focus {
    var id: Int?
    var userID: Int
    var focusUserID: Int
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 关注时间    
    
    init(id: Int? = nil, userID: Int, focusUserID: Int, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.focusUserID = focusUserID
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        self.focusUserID = jsonData["focusUserID"].intValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue        
    }
}
