//
//  ADBanner.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct ADBanner {
    var id: Int?

    var imageURL: String
    var title: String
    var link: String // 链接跳转
    var type: String // 类型[首页、生活]
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var remark: String? // 备注
    
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, imageURL: String, title: String, link: String, type: String, status: Int? = 1) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.link = link
        self.type = type
        self.status = status        
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.imageURL = jsonData["imageURL"].stringValue
        self.title = jsonData["title"].stringValue
        self.link = jsonData["link"].stringValue
        self.type = jsonData["type"].stringValue
        self.status = jsonData["status"].intValue
        self.remark = jsonData["remark"].stringValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
