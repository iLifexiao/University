//
//  UtilityMethod.swift
//  University
//
//  Created by 肖权 on 2018/11/12.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation

public func textSize(text : String, font : UIFont, maxSize : CGSize) -> CGSize{
    return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
}

public func unixTime2StringDate(_ time: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
    let date = Date(timeIntervalSince1970: time)
    
    let dformatter = DateFormatter()
    dformatter.dateFormat = format
    
    return dformatter.string(from: date)
}

