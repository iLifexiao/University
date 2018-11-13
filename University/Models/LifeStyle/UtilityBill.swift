//
//  UtilityBill.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct UtilityBill {
    var id: Int?
    
    var site: String
    var time: String
    var electricityPrice: Float
    var waterPrice: Float
    var hotWaterPrice: Float? // 有的宿舍采用热水器
    var remark: String? // 备注
    
    var status: Int? // 状态[0, 1] = [禁止, 正常]
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    
    init(id: Int? = nil, site: String, time: String, electricityPrice: Float, waterPrice: Float, hotWaterPrice: Float?, remark: String?, status: Int? = 1) {
        self.id = id
        self.site = site
        self.time = time
        self.electricityPrice = electricityPrice
        self.waterPrice = waterPrice
        self.hotWaterPrice = hotWaterPrice
        
        self.status = status
        self.remark = remark
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        
        self.site = jsonData["site"].stringValue
        self.time = jsonData["time"].stringValue
        self.electricityPrice = jsonData["electricityPrice"].floatValue
        self.waterPrice = jsonData["waterPrice"].floatValue
        self.hotWaterPrice = jsonData["hotWaterPrice"].floatValue
        self.remark = jsonData["remark"].stringValue
        
        self.status = jsonData["status"].intValue
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}

