//
//  PartTimeJob.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct PartTimeJob {
    var id: Int?
    
    var title: String
    var imageURL: String
    var company: String
    var price: Float
    var introduce: String
    var site: String
    var deadLine: String
    var phone: String
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 发布时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, title: String, imageURL: String, company: String, price: Float, introduce: String, site: String, deadLine: String, phone: String, status: Int? = 1) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.company = company
        self.price = price
        self.introduce = introduce
        self.site = site
        self.deadLine = deadLine
        self.phone = phone
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.title = jsonData["title"].stringValue
        self.imageURL = jsonData["imageURL"].stringValue
        self.company = jsonData["company"].stringValue
        self.price = jsonData["price"].floatValue
        self.introduce = jsonData["introduce"].stringValue
        self.site = jsonData["site"].stringValue
        self.deadLine = jsonData["deadLine"].stringValue
        self.phone = jsonData["phone"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
