//
//  ViewManager.swift
//  University
//
//  Created by 肖权 on 2018/11/24.
//  Copyright © 2018 肖权. All rights reserved.
//

import Foundation

final class ViewManager {
    static let share = ViewManager()
    
    var secondNVC: UINavigationController?
    private init() {}
}
