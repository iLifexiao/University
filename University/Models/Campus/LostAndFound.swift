//
//  LostAndFound.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct LostAndFound {
    var id: Int?
    var userID: Int
    
    var imageURL: [String]? // 上传 0~9张的图片
    var title: String
    var content: String
    var time: String
    var site: String
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, userID: Int, imageURL: [String]?, title: String, content: String, time: String, site: String, status: Int? = 1, remark: String?) {
        self.id = id
        self.userID = userID
        self.imageURL = imageURL
        self.title = title
        self.content = content
        self.time = time
        self.site = site
        self.remark = remark
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.imageURL = jsonData["imageURL"].arrayObject as? [String]
        self.title = jsonData["title"].stringValue
        self.content = jsonData["content"].stringValue
        self.time = jsonData["time"].stringValue
        self.site = jsonData["site"].stringValue
        self.remark = jsonData["remark"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
