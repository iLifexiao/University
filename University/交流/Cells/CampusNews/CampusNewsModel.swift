//
//  CampusNewsModel.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

struct CampusNewsModel {
    var id: String?
    var title: String?
    var newsImage: UIImage?
    var original: String?
    var readCount: Int = 0
    var postDate: String?
    
    init(id: String?, title: String?, newsImage: UIImage?, original: String?, readCount: Int = 0, postDate: String?) {
        self.title = title
        self.newsImage = newsImage
        self.original = original
        self.readCount = readCount
        self.postDate = postDate
    }
}
