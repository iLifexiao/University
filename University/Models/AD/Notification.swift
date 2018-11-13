//
//  Notification.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Notification {
    var id: Int?
    
    var title: String // 标题
    var content: String // 内容
    var type: String // 类型
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var remark: String? // 备注
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, title: String, content: String, type: String, status: Int? = 1) {
        self.id = id
        self.title = title
        self.content = content
        self.type = type
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.title = jsonData["title"].stringValue
        self.content = jsonData["content"].stringValue
        self.type = jsonData["type"].stringValue
        
        self.status = jsonData["status"].intValue
        self.remark = jsonData["remark"].stringValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
