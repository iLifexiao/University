//
//  ReadingModel.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

struct ReadingModel {
    var id: String?
    var icon: UIImage?
    var name: String?
    var author: String?
    var readCount: Int = 0
    var bookPages: Int = 0
    var detail: String?
    
    init(id: String?, icon: UIImage?, name: String?, author: String?, readCount: Int = 0, bookPages: Int = 0, detail: String?) {
        self.id = id
        self.icon = icon
        self.name = name
        self.author = author
        self.readCount = readCount
        self.bookPages = bookPages
        self.detail = detail
    }
}
