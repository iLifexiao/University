//
//  IdleGood.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct IdleGood {
    var id: Int?
    var userID: Int
    
    var imageURLs: [String]? // 可以上传 0~9 图片，最多9张
    var title: String
    var content: String
    var originalPrice: Float
    var price: Float
    var type: String
    
    var status: Int? // 状态[0, 1, 2] = [下架, 正常, 删除]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, userID: Int, imageURLs: [String]?, title: String, content: String, originalPrice: Float, price: Float, type: String, status: Int? = 1) {
        self.id = id
        self.userID = userID
        self.imageURLs = imageURLs
        self.title = title
        self.content = content
        self.originalPrice = originalPrice
        self.price = price
        self.type = type
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.imageURLs = jsonData["imageURLs"].arrayObject as? [String]
        self.title = jsonData["title"].stringValue
        self.content = jsonData["content"].stringValue
        self.originalPrice = jsonData["originalPrice"].floatValue
        self.price = jsonData["price"].floatValue
        self.type = jsonData["type"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
