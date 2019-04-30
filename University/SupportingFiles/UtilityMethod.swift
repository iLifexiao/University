//
//  UtilityMethod.swift
//  University
//
//  Created by 肖权 on 2018/11/12.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation
import SwiftDate

public func textSize(text : String, font : UIFont, maxSize : CGSize) -> CGSize{
    return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : font], context: nil).size
}

public func unixTime2StringDate(_ time: TimeInterval, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
    let date = Date(timeIntervalSince1970: time)
    
    let dformatter = DateFormatter()
    dformatter.dateFormat = format
    
    return dformatter.string(from: date)
}

public func friendDateByUnixTime(_ time: TimeInterval) -> String {
    let aDate = Date(timeIntervalSince1970: time)

    if aDate.isToday {
        return aDate.toFormat("HH:mm:ss", locale: Locales.chineseChina)
    }
    
    if aDate.isYesterday {
        return "昨天 " + aDate.toFormat("HH:mm:ss", locale: Locales.chineseChina)
    }
    
    if (aDate - 1.days).isYesterday {
        return "前天 " + aDate.toFormat("HH:mm:ss", locale: Locales.chineseChina)
    }
    
    if aDate.year == Date().year {
        return aDate.toFormat("MM-dd HH:mm:ss", locale: Locales.chineseChina)
    }
    
    return aDate.toFormat("yyyy-MM-dd", locale: Locales.chineseChina)
}
