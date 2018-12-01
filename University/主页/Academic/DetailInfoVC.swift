//
//  DetailInfoVC.swift
//  University
//
//  Created by 肖权 on 2018/11/13.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

class DetailInfoVC: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var academic: Academic?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "公告详细"
        initData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    private func initData() {
        if let academic = academic {
            titleLabel.text = academic.title
            typeLabel.text = academic.type
            timeLabel.text = academic.time
            contentTextView.text = academic.content
            // 关闭赋值后自动滚动
            contentTextView.layoutManager.allowsNonContiguousLayout = false
        }
    }
}
