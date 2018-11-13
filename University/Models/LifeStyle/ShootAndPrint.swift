//
//  ShootAndPrint.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct ShootAndPrint {
    var id: Int?
    
    var name: String
    var imageURL: String
    var introduce: String
    var content: String
    var time: String //用字符串来改变时间显示
    var site: String
    var phone: String
    
    var wechat: String?
    var qq: String?
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, name: String, imageURL: String, introduce: String, content: String, time: String, site: String, phone: String, wechat: String?, qq: String?, status: Int? = 1) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.introduce = introduce
        self.content = content
        self.time = time
        self.site = site
        self.phone = phone
        self.wechat = wechat
        self.qq = qq
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.name = jsonData["name"].stringValue
        self.imageURL = jsonData["imageURL"].stringValue
        self.introduce = jsonData["introduce"].stringValue
        self.content = jsonData["content"].stringValue
        self.time = jsonData["time"].stringValue
        self.site = jsonData["site"].stringValue
        self.phone = jsonData["phone"].stringValue
        self.wechat = jsonData["wechat"].stringValue
        self.qq = jsonData["qq"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
