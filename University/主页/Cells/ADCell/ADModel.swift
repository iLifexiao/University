//
//  ADModel.swift
//  University
//
//  Created by 肖权 on 2018/10/23.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

struct ADModel {
    var icon: UIImage?
    var title: String?
    var content: String?
    var type: String?    
    
    init(icon: UIImage?, title: String? = "Failed", content: String? = "加载失败......", type: String? = "错误") {
        self.icon = icon
        self.title = title
        self.content = content
        self.type = type
    }
}
