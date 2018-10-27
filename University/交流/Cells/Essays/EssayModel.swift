//
//  EssayModel.swift
//  University
//
//  Created by 肖权 on 2018/10/25.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

struct EssayModel {
    var essayID: String? // 唯一标识
    var userHeadImage: UIImage?
    var userName: String?
    var postTime: String?
    var title: String?
    var type: String
    var content: String?
    var readCount: Int = 0
    var likeCount: Int = 0
    var commitCount: Int = 0
    
    init(essayID: String?, userHeadImage: UIImage?, userName: String?, postTime: String?, title: String?, type: String, content: String?, readCount: Int = 0, likeCount: Int = 0, commitCount: Int = 0) {
        self.essayID = essayID
        self.userHeadImage = userHeadImage
        self.userName = userName
        self.postTime = postTime
        self.title = title
        self.type = type
        self.content = content
        // 阅读数据
        self.readCount = readCount
        self.likeCount = likeCount
        self.commitCount = commitCount
        
    }
}
