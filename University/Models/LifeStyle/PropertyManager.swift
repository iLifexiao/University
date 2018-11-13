//
//  PropertyManager.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct PropertyManager {
    var id: Int?
    
    var imageURL: String
    var name: String
    var phone: String
    var ability: String // 工作
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, imageURL: String, name: String, phone: String, ability: String, status: Int? = 1) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.phone = phone
        self.ability = ability
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.imageURL = jsonData["imageURL"].stringValue
        self.name = jsonData["name"].stringValue
        self.phone = jsonData["phone"].stringValue
        self.ability = jsonData["ability"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
