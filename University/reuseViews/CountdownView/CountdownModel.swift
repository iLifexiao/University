//
//  CountdownModel.swift
//  University
//
//  Created by 肖权 on 2018/10/27.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

struct CountdownModel {
    var date: String?
    var event: String = "大事件"
    var day: Int = 0
    
    init(date: String?, event: String = "大事件", day: Int = 0) {
        self.date = date
        self.event = event
        self.day = day
    }
}
