//
//  RegexMethod.swift
//  University
//
//  Created by 肖权 on 2018/12/4.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation

final class Regex {
    public class func checkPhone(_ number: String) -> Bool {
        // 以13/4/5/7/8开头，后面9个数字
        let pattern = "(^1[34578]\\d{9}$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return pred.evaluate(with: number);
    }
    
    public class func checkPwd(_ password: String) -> Bool {
        // 6到16位字符和_.*组合成的密码
        let pattern = "(^[a-z0-9A-Z_*.]{6,16}$)";
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        
        return pred.evaluate(with: password);
    }
}
