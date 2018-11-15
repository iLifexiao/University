//
//  GlobalData.swift
//  University
//
//  Created by 肖权 on 2018/11/15.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation

final class GlobalData {
    static let sharedInstance = GlobalData()
    
    var userID: Int = 0
    var studentID: Int = 0
        
    private init() {}
}
