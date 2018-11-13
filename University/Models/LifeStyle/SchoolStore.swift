//
//  SchoolStore.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct SchoolStore {
    var id: Int?
    
    var name: String
    var imageURL: String
    var introduce: String
    var content: String
    var type: String
    var site: String
    var time: String //营业时间
    var phone: String
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var remark: String? // 备注
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, name: String, imageURL: String, introduce: String, content: String, type: String, site: String, time: String, phone: String, status: Int? = 1) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.introduce = introduce
        self.content = content
        self.type = type
        self.site = site
        self.time = time
        self.phone = phone
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.name = jsonData["name"].stringValue
        self.imageURL = jsonData["imageURL"].stringValue
        self.introduce = jsonData["introduce"].stringValue
        self.content = jsonData["content"].stringValue
        self.type = jsonData["type"].stringValue
        self.time = jsonData["time"].stringValue
        self.site = jsonData["site"].stringValue
        self.phone = jsonData["phone"].stringValue        
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
