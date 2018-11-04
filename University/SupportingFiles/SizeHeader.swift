//
//  SizeHeader.swift
//  XXKit
//
//  Created by 肖权 on 18/8/8.
//  Copyright © 2018年 肖权. All rights reserved.
//

import UIKit

// 常用物理常量，添加前缀K
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.size.height

// 适配IphoneX系列
let IsIphoneXSeries = (ScreenHeight == 812.0 || ScreenHeight == 896.0) ? true : false
let TopBarHeight = (IsIphoneXSeries ? CGFloat(88) : CGFloat(64))
let TabBarHeight = (IsIphoneXSeries ? CGFloat(83) : CGFloat(49))

//屏幕适配（以iPhone 6为基础）
func FitWidth(value: Float) -> Float {
    return (value / 750.0 * Float(ScreenWidth))
}
func FitHeight(value: Float) -> Float {
    return (value / 1334.0 * Float(ScreenHeight))
}
func FitFont(size: Float) -> Float {
    return size * Float(ScreenWidth) / 750.0
}

//颜色定义
func XQColor(r: Float, g: Float, b: Float) -> UIColor {
    return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: 1.0)
}

func ColorRGB(value: Float) -> UIColor {
    return UIColor(red: CGFloat(value / 255.0), green: CGFloat(value / 255.0), blue: CGFloat(value / 255.0), alpha: 1.0)
}
