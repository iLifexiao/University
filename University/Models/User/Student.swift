//
//  Student.swift
//  App
//
//  Created by 肖权 on 2018/11/7.
//

import SwiftyJSON

struct Student {
    var id: Int?
    var userID: Int
    
    var number: String // 学号
    var password: String // 学籍密码
    var name: String // 姓名
    var sex: String // 性别
    var age: Int // 年龄
    var school: String // 学校
    var major: String // 专业
    var year: String // 入学年份
    var remark: String? // 备注
        
    var createdAt: TimeInterval? // 创建时间
    var updatedAt: TimeInterval? // 更新时间
    
    init(id: Int? = nil, userID: Int,  number: String, password: String, name: String, sex: String, age: Int, school: String, major: String, year: String) {
        self.id = id
        self.userID = userID
        self.number = number
        self.password = password
        self.name = name
        self.sex = sex
        self.age = age
        self.school = school
        self.major = major
        self.year = year
    }
    
    init(jsonData: JSON) {
        self.id = jsonData["id"].intValue
        self.userID = jsonData["userID"].intValue
        
        self.number = jsonData["number"].stringValue
        self.password = jsonData["password"].stringValue
        self.name = jsonData["name"].stringValue
        self.sex = jsonData["sex"].stringValue
        self.age = jsonData["age"].intValue
        self.school = jsonData["school"].stringValue
        self.major = jsonData["major"].stringValue
        self.year = jsonData["year"].stringValue
        self.remark = jsonData["remark"].stringValue        
        
        self.createdAt = jsonData["createdAt"].doubleValue
        self.updatedAt = jsonData["updatedAt"].doubleValue
    }
}
