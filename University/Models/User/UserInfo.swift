//
//  UserInfo.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct UserInfo {
    var id: Int?
    var userID: Int // 外键
    
    var nickname: String // 默认
    var profilephoto: String // 默认：「/image/7.jpg」
    var sex: String? // 性别「保密」
    var age: Int? // 年龄「18」
    var phone: String? // 电话
    var email: String? // 邮箱
    var introduce: String? // 自我介绍「这个人很cool，还没有介绍」
    var type: String? // 默认[普通, SVIP]
    var remark: String? // 备注
    
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, userID: Int, nickname: String, profilephoto: String, sex: String? = "保密", age: Int? = 18, phone: String? = "17777777777", email: String? = "17777777777@163.com", introduce: String? = "这个人很cool，还没有介绍", type: String? = "普通") {
        self.id = id
        self.userID = userID
        self.nickname = nickname
        self.profilephoto = profilephoto
        self.sex = sex
        self.age = age
        self.phone = phone
        self.email = email
        self.introduce = introduce
        self.type = type
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.nickname = jsonData["nickname"].stringValue
        self.profilephoto = jsonData["profilephoto"].stringValue
        self.sex = jsonData["sex"].stringValue
        self.age = jsonData["age"].intValue
        self.phone = jsonData["phone"].stringValue
        self.type = jsonData["type"].stringValue
        self.email = jsonData["email"].stringValue
        self.introduce = jsonData["introduce"].stringValue
        self.type = jsonData["type"].stringValue
        self.remark = jsonData["remark"].stringValue
        
        
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
