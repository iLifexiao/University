//
//  AddressList.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct AddressList {
    var id: Int?
    
    var name: String
    var phone: String
    var type: String
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, name: String, phone: String, type: String,  status: Int? = 1, remark: String?) {
        self.id = id
        self.name = name
        self.phone = phone
        self.type = type
        self.remark = remark
        self.status = status
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.name = jsonData["name"].stringValue
        self.phone = jsonData["phone"].stringValue
        self.type = jsonData["type"].stringValue
        self.remark = jsonData["remark"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}

