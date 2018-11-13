//
//  User.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct User {
    var id: Int?
    var account: String // 电话，用于注册
    var password: String // 加密的密码
        
    var status: Int? // 状态[0, 1, 2] = [禁登、正常、注销]
    var createdAt: TimeInterval? // 注册时间
    
    // 便于帐号登录注册，使用默认参数提供不重要的信息
    init(id: Int? = nil, account: String, password: String, status: Int? = 1) {
        self.id = id
        self.account = account
        self.password = password        
        self.status = status        
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.account = jsonData["account"].stringValue
        self.password = jsonData["password"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue        
    }
}
