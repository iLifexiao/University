//
//  ADHeaderView.swift
//  University
//
//  Created by 肖权 on 2018/10/24.
//  Copyright © 2018 肖权. All rights reserved.
//

import UIKit

@objc protocol AccessButtonDelegate {
    func pressAccess(title: String?)
}

class ADHeaderView: UIView {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessButton: UIButton!
    
    weak var delegate: AccessButtonDelegate?
    
    func setTips(_ title: String, icon: UIImage? = nil) {
        titleLabel.text = title
        if icon != nil {
            iconImage.image = icon
        }
    }
    
    func setAccessButtonTitle(_ title: String) {
        accessButton.setTitle(title, for: .normal)
    }
    
    @IBAction func pressAccessButton(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.pressAccess(title: sender.currentTitle)
        }
    }
    
}
