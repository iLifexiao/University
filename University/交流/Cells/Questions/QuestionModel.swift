//
//  QuestionModel.swift
//  University
//
//  Created by 肖权 on 2018/10/26.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class QuestionModel {
    var id: String?
    var question: String?
    var answerCount = 0
    
    init(id: String?, question: String?, answerCount: Int = 0) {
        self.id = id
        self.question = question
        self.answerCount = answerCount
    }
}
