//
//  Club.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Club {
    var id: Int?
    
    var imageURL: String
    var name: String
    var introduce: String
    var time: String
    var numbers: Int
    var rank: String
    var type: String
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
        
    init(id: Int? = nil, imageURL: String, name: String, introduce: String, time: String, numbers: Int, rank: String, type: String, status: Int? = 1) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.introduce = introduce
        self.time = time
        self.numbers = numbers
        self.rank = rank
        self.type = type
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.imageURL = jsonData["imageURL"].stringValue
        self.name = jsonData["name"].stringValue
        self.introduce = jsonData["introduce"].stringValue
        self.time = jsonData["time"].stringValue
        self.numbers = jsonData["numbers"].intValue
        self.rank = jsonData["rank"].stringValue
        self.type = jsonData["type"].stringValue
        self.remark = jsonData["remark"].stringValue        
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
