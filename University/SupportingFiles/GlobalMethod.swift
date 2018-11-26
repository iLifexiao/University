//
//  GlobalMethod.swift
//  University
//
//  Created by 肖权 on 2018/11/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public func exitUser() {
    // 退出登录的时候，清除用户数据
    UserDefaults.standard.set(0, forKey: userIDKey)
    UserDefaults.standard.set(0, forKey: studentIDKey)
    // 默认用户信息
    UserDefaults.standard.set("用户未登录", forKey: userNameKey)
    UserDefaults.standard.set("/image/defalut.png", forKey: userHeadKey)
    GlobalData.sharedInstance.userID = 0
    GlobalData.sharedInstance.studentID = 0
    GlobalData.sharedInstance.userName = "用户未登录"
    GlobalData.sharedInstance.userHeadImage = "/image/default.png"
}

/* 回调传值发生了问题
// 1. 通过外关联参数（引用->地址）来组织重复代码(等待重构)
// 如果是异步操作的话，需要采用以下方式：
public func checkUserStatus(_ flag: inout Int) {
    // 1. 在闭包中需要捕获该引用(捕获后，成为一个不可变引用)
    // 2. 拷贝该变量地址，成为一个变量
    // 3. 注意点，如果设置的是计算属性，那么在你拷贝的时候，相当于进行了赋值（这里我需要修改一个不同的类型GET）
    Alamofire.request(baseURL + "/api/v1/user/\(GlobalData.sharedInstance.userID)/userstatus", headers: headers).responseJSON { [flag] response in
        var flag = flag
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            flag = json["status"].intValue
            print("json[status]: \(flag)")
        case .failure(let error):
            print(error)
        }
    }
}
*/
